# zoplanner-infrastructure

Infrastructure and deployment guides for the ZoPlanner system.

## Kom igång snabbt (Windows / PowerShell)

1. Klona alla repo till en mapp (t.ex. Desktop/ZoPlanner):

```powershell
cd ~/Desktop

if (-not (Test-Path "ZoPlanner" -PathType Container)) {
    mkdir ZoPlanner | Out-Null
}

Write-Host ("ZoPlanner-mapp klar: {0:HH:mm yyyy-MM-dd}" -f (Get-Date))

cd ZoPlanner

$repos = @(
    "zoplanner-api",
    "zoplanner-service",
    "zoplanner-frontend",
    "zoplanner-notificationservice",
    "zoplanner-infrastructure"
)

foreach ($repo in $repos) {
    if (Test-Path $repo -PathType Container) {
        Write-Host "Repo $repo finns redan – kör git pull..."
        Push-Location $repo
        git pull
        Pop-Location
    }
    else {
        Write-Host "Klonar $repo..."
        git clone "https://github.com/zocom-utveckling/$repo.git"
    }
}
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
