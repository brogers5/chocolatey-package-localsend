[CmdletBinding()]
param([switch] $Force)
Import-Module au
Import-Module PowerShellForGitHub

$owner = 'localsend'
$repository = 'localsend'

function global:au_GetLatest {
    $latestRelease = (Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Latest)[0]
    $version = $latestRelease.tag_name.Substring(1)

    return @{
        SoftwareVersion = $version
        Version         = $version #This may change if building a package fix version
    }
}

function global:au_BeforeUpdate ($Package) {
    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_SearchReplace {
    $parsedVersion = [version] $Latest.SoftwareVersion
    $nextBuildVersion = [version]::new($parsedVersion.Major, $parsedVersion.Minor, $parsedVersion.Build + 1)

    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)'                             = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<licenseUrl>)[^<]*(</licenseUrl>)'                                         = "`$1https://github.com/$owner/$repository/blob/v$($Latest.SoftwareVersion)/LICENSE`$2"
            '(<projectSourceUrl>)[^<]*(</projectSourceUrl>)'                             = "`$1https://github.com/$owner/$repository/tree/v$($Latest.SoftwareVersion)`$2"
            '(<releaseNotes>)[^<]*(</releaseNotes>)'                                     = "`$1https://github.com/$owner/$repository/releases/tag/v$($Latest.SoftwareVersion)`$2"
            '(<copyright>)[^<]*(</copyright>)'                                           = "`$1Copyright (c) 2022-$(Get-Date -Format yyyy) Tien Do Nam`$2"
            "(\<dependency .+?`"$($Latest.PackageName).portable`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.SoftwareVersion), $nextBuildVersion)`""
        }
    }
}

Update-Package -ChecksumFor None -Force:$Force -NoReadme
