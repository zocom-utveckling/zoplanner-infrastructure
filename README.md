# zoplanner-infrastructure

Infrastructure and deployment guides for the ZoPlanner system.

## Kom igång snabbt (Windows / PowerShell)

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

2. Kör PowerShell-scriptet som syncar alla repo och startar om Docker-stacken:

```powershell
cd ~/Desktop/ZoPlanner
.\zoplanner-infrastructure\sync-and-start.ps1
```

> Körs från parent-mappen där alla repo ligger (`zoplanner-api`, `zoplanner-service`, osv).

## Guides

| Guide | Beskrivning |
|-------|-------------|
| [START APP WITH DOCKER.md](./START%20APP%20WITH%20DOCKER.md) | 🚀 Komplett guide för att starta hela ZoPlanner-systemet med Docker (5 containrar) |
| [sync-and-start.README.md](./sync-and-start.README.md) | Script för att synka repos och starta om efter git push |
