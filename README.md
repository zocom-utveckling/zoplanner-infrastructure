# zoplanner-infrastructure


## Script för git clone 

1. Klona alla repo till en mapp (t.ex. Desktop/ZoPlanner):

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
git clone https://github.com/zocom-utveckling/zoplanner-infrastructure.git
Write-Host "Repos cloned." -ForegroundColor Green

#

```

2. Script för att git pull och starta om docker.

```powershell
$folders = @(
  "zoplanner-api",
  "zoplanner-service",
  "zoplanner-frontend",
  "zoplanner-notificationservice",
  "zoplanner-infrastructure"
)

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

cd .\zoplanner-api/webapi
docker compose -p zoplanner down --remove-orphans
docker-compose -p zoplanner up -d --build
cd ..\..

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
