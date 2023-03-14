﻿$ErrorActionPreference = 'Stop'

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$nuspecFileRelativePath = Join-Path -Path $currentPath -ChildPath 'localsend.nuspec'

[xml] $nuspec = Get-Content $nuspecFileRelativePath
$version = $nuspec.package.metadata.version

$global:Latest = @{
    Url64 = Get-SoftwareUri -Version $version
}

Write-Host 'Downloading...'
Get-RemoteFiles -Purge -NoSuffix

Write-Host 'Creating package...'
choco pack $nuspecFileRelativePath
