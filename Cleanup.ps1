if ((Get-ChildItem $env:USERPROFILE\PycharmProjects\*).Count -lt 1)
{
    Read-Host -Prompt "There are no projects in the PycharmProjects folder"
    Throw "There are no projects in the PycharmProjects folder"
}

if (-not $(Test-Path -Path D:/))
{
    Read-Host -Prompt "Please connect external drive first"
    Throw "Please connect external drive first"
}

$name = ""
while ($name.Length -eq 0)
{
    $name = Read-Host "What is the user's name?"
}

$folder = "D:\Recordings\Test - $name"

# Create directory on the external HDD, if it doesn't exist already
if (Test-Path -Path $folder)
{
    Throw "A recording already exists for this user"
}
New-Item -ItemType Directory -Path $folder

# Move PyCharm Project
Move-Item $env:USERPROFILE\PycharmProjects\* $folder

# Reset PyCharm
Stop-Process -Name pycharm64 -ea SilentlyContinue
Remove-Item -Path $env:USERPROFILE\.PyCharm2017.1\config\options\jdk.table.xml
Remove-Item -Path $env:USERPROFILE\.PyCharm2017.1\config\options\recentProjectDirectories.xml

# Move PyCharm Logs
Get-ChildItem -Path $env:USERPROFILE\.PyCharm2017.1\system\log\* | Move-Item -Destination $folder

# Remove any virtualenvs
Get-ChildItem -Path $env:USERPROFILE -Filter pip-selfcheck.json -Recurse | Select-Object -ExpandProperty DirectoryName | Remove-Item -Force -Recurse

# Move Camtasia files
Get-ChildItem -Path "$($env:USERPROFILE)\Documents\Camtasia Studio" -File | Move-Item -Destination $folder


## 

# Get pattern for current directory, and make a regex pattern that matches slashes and backslashes
$pattern = $pwd -replace "\\", "[/\\]"
$boxes = vagrant global-status | sls -Pattern $pattern
$box_ids = 
