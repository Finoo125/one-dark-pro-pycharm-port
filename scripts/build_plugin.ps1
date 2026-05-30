param()

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$projectRoot = Split-Path -Parent $PSScriptRoot
$resourcesRoot = Join-Path $projectRoot 'src\main\resources'
$pluginXmlPath = Join-Path $resourcesRoot 'META-INF\plugin.xml'

if (-not (Test-Path -LiteralPath $pluginXmlPath)) {
    throw "Missing plugin descriptor: $pluginXmlPath"
}

[xml]$pluginXml = Get-Content -LiteralPath $pluginXmlPath
$pluginId = $pluginXml.'idea-plugin'.id
$version = $pluginXml.'idea-plugin'.version

if ([string]::IsNullOrWhiteSpace($pluginId) -or [string]::IsNullOrWhiteSpace($version)) {
    throw 'The plugin id and version must be defined in META-INF\plugin.xml.'
}

$buildRoot = Join-Path $projectRoot '.build'
$stagingRoot = Join-Path $buildRoot 'plugin'
$distRoot = Join-Path $projectRoot 'dist'
$zipPath = Join-Path $distRoot "$pluginId-$version.zip"
$jarPath = Join-Path $distRoot "$pluginId-$version.jar"

Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $jarPath -Force -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Path $stagingRoot -Force | Out-Null
New-Item -ItemType Directory -Path $distRoot -Force | Out-Null

Copy-Item -Path (Join-Path $resourcesRoot '*') -Destination $stagingRoot -Recurse -Force

Add-Type -AssemblyName System.IO.Compression

$fileStream = [System.IO.File]::Open($zipPath, [System.IO.FileMode]::Create)
try {
    $archive = New-Object System.IO.Compression.ZipArchive($fileStream, [System.IO.Compression.ZipArchiveMode]::Create, $false)
    try {
        Get-ChildItem -LiteralPath $stagingRoot -Recurse -File | ForEach-Object {
            $relativePath = $_.FullName.Substring($stagingRoot.Length).TrimStart('\').Replace('\', '/')
            $entry = $archive.CreateEntry($relativePath, [System.IO.Compression.CompressionLevel]::Optimal)
            $entryStream = $entry.Open()
            $sourceStream = [System.IO.File]::OpenRead($_.FullName)
            try {
                $sourceStream.CopyTo($entryStream)
            }
            finally {
                $sourceStream.Dispose()
                $entryStream.Dispose()
            }
        }
    }
    finally {
        $archive.Dispose()
    }
}
finally {
    $fileStream.Dispose()
}
Rename-Item -LiteralPath $zipPath -NewName ([System.IO.Path]::GetFileName($jarPath))

Write-Output "Built $jarPath"
