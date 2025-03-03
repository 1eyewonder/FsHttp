
$docuIndexYamlHeader = @'
---
IMPORTANT: This file is generated by `./docu.ps1`. Please don't edit it manually!

title: FsHttp Overview
index: 1
---

'@
$readmeContent = Get-Content ./README.md -Raw
($docuIndexYamlHeader + $readmeContent) | Out-File ./src/docs/index.md




if ((Test-Path .\.fsdocs) -eq $true) {
    Remove-Item .\.fsdocs\ -Force -Recurse
}

dotnet tool restore
dotnet build ./src/FsHttp/FsHttp.fsproj -c Release -f net6.0

# what a hack...
if ($null -eq $args[0]) {
    $mode = "build"
} else {
    $mode = "watch"
}

dotnet fsdocs `
    $mode `
    --clean `
    --sourcefolder ./src `
    --input ./src/docs `
    --output ./docs `
    --properties Configuration=Release `
    --sourcerepo https://github.com/fsprojects/FsHttp/blob/master/src `
    --parameters root /FsHttp/ 
