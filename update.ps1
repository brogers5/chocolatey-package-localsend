[CmdletBinding()]
param([switch] $Force)
Import-Module au
Import-Module PowerShellForGitHub

$owner = 'localsend'
$repository = 'localsend'

function global:au_GetLatest {
    # Get multiple recent releases to find one with the required underlying asset
    $releases = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository
    
    foreach ($release in $releases) {
        $version = $release.tag_name.Substring(1)
        $expectedAssetFileName = "LocalSend-$version-windows-x86-64.zip"
        
        # Check if the required asset exists in this release
        $asset = $release.assets | Where-Object { $_.name -eq $expectedAssetFileName }
        
        if ($asset) {
            return @{
                SoftwareVersion = $version
                Version         = $version #This may change if building a package fix version
            }
        }
        else {
            Write-Warning "Skipping over LocalSend release v$version, as it does not contain the required asset: $expectedAssetFileName"
        }
    }
    
    throw 'No release was found with the required asset (LocalSend-*-windows-x86-64.zip)!'
}

function global:au_BeforeUpdate ($Package) {
    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)'                             = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<licenseUrl>)[^<]*(</licenseUrl>)'                                         = "`$1https://github.com/$owner/$repository/blob/v$($Latest.SoftwareVersion)/LICENSE`$2"
            '(<projectSourceUrl>)[^<]*(</projectSourceUrl>)'                             = "`$1https://github.com/$owner/$repository/tree/v$($Latest.SoftwareVersion)`$2"
            '(<releaseNotes>)[^<]*(</releaseNotes>)'                                     = "`$1https://github.com/$owner/$repository/releases/tag/v$($Latest.SoftwareVersion)`$2"
            '(<copyright>)[^<]*(</copyright>)'                                           = "`$1Copyright (c) 2022-$(Get-Date -Format yyyy) Tien Do Nam`$2"
            "(\<dependency .+?`"$($Latest.PackageName).portable`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
        }
    }
}

Update-Package -ChecksumFor None -Force:$Force -NoReadme
