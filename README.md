# zoplanner-infrastructure

- 📥 **1. Script för att ladda ner hela repot** – Klonar alla projekt i rätt struktur.
- 🔄 **2. Script för git pull & starta om Docker** – Uppdaterar alla repos och bygger om containrarna.

## 1. Script för ny git clone

```powershell
# Skapa en mapp för projektet på skrivbordet

cd $HOME\Desktop
$timestamp = Get-Date -Format "yy-MM-dd_HH.mm"
$folderName = "zoplanner_$timestamp"

New-Item -ItemType Directory -Name $folderName
cd $folderName

git clone https://github.com/zocom-utveckling/zoplanner-api.git
git clone https://github.com/zocom-utveckling/zoplanner-service.git
git clone https://github.com/zocom-utveckling/zoplanner-frontend.git
git clone https://github.com/zocom-utveckling/zoplanner-notificationservice
Write-Host "Repos cloned." -ForegroundColor Green
cd .\zoplanner-api/webapi

Write-Host "Please add .env file with credentials inside .\zoplanner-api\webapi before proceeding." -ForegroundColor Green
Read-Host "Press enter to continue."


docker-compose -p zoplanner up -d --build

#

```
## 2. Script för uppdatera repon och starta om docker

```powershell


# Stop on first error
$ErrorActionPreference = "Stop"

# Always determine base folder correctly
if ((Split-Path -Leaf (Get-Location)) -eq "webapi") {
    # We are inside zoplanner-api\webapi
    Set-Location "..\.."
}

# We are now guaranteed to be in base folder

$basePath = (Get-Location).Path

$folders = @(
  "zoplanner-api",
  "zoplanner-service",
  "zoplanner-frontend",
  "zoplanner-notificationservice"
)

# Pull all repos
foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "Pulling $folder ..." -ForegroundColor Cyan
        Push-Location $folder
        git pull
        Pop-Location
    }
    else {
        Write-Host "$folder not found!" -ForegroundColor Red
    }
}

# Go to webapi
Set-Location ".\zoplanner-api\webapi"

docker compose -p zoplanner down --remove-orphans
docker compose -p zoplanner up -d --build

# Return to base
Set-Location $basePath

Write-Output @"
Done.
Frontend: http://localhost:3000
Swagger - .NET: http://localhost:5027/swagger/index.html
Swagger - Java API: http://localhost:8080/swagger-ui/index.html
Swagger - Notification: http://localhost:8082/swagger-ui/index.html
"@

Write-Host "Command Completed Successfully" -ForegroundColor Green

#
```

> Körs från parent-mappen där alla repo ligger (`zoplanner-api`, `zoplanner-service`, osv).

## Guides

| Guide | Beskrivning |
|-------|-------------|
| [START APP WITH DOCKER.md](./START%20APP%20WITH%20DOCKER.md) | 🚀 Komplett guide för att starta hela ZoPlanner-systemet med Docker (5 containrar) |
| [sync-and-start.README.md](./sync-and-start.README.md) | Script för att synka repos och starta om efter git push |
