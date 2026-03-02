# sync-and-start.sh

Script för att synka alla ZoPlanner-repos och starta om Docker-stacken efter att någon har pushat ändringar.

## Ladda ner alla repo första gången

```bash
# Skapa en mapp för projektet på skrivbordet
cd ~/desktop
FOLDER="ZoPlanner-$(date '+%Y-%m-%d_%H-%M')"
mkdir "$FOLDER"
echo "ZoPlanner skapades: $FOLDER $(date '+%H:%M %Y-%m-%d')"
cd "$FOLDER"

git clone https://github.com/zocom-utveckling/zoplanner-api.git
git clone https://github.com/zocom-utveckling/zoplanner-service.git
git clone https://github.com/zocom-utveckling/zoplanner-frontend.git
git clone https://github.com/zocom-utveckling/zoplanner-notificationservice
git clone https://github.com/zocom-utveckling/zoplanner-infrastructure.git

cd ./zoplanner-api/webapi/
notepad .env
# Kopiera in info till .env

```

## Scriptet för att uppdatera repo och docker



### Windows (PowerShell)

```powershell
# Stop script on first error (like set -e)
$ErrorActionPreference = "Stop"

# List of repositories
$repos = @(
    "zoplanner-api",
    "zoplanner-service",
    "zoplanner-frontend",
    "zoplanner-notificationservice"
)

# Pull all repos
foreach ($dir in $repos) {
    if (Test-Path $dir -PathType Container) {
        Write-Host "Pulling $dir..."
        
        Push-Location $dir
        git pull
        Pop-Location
    }
}

# Restart stack (use -p zoplanner so same volumes are always used, data persists)
Set-Location "zoplanner-api\webapi"

docker-compose -p zoplanner down
docker-compose -p zoplanner up -d --build
```

### Mac och Linux

```bash
#!/bin/bash
set -e

# Pull all repos
for dir in zoplanner-api zoplanner-service zoplanner-frontend zoplanner-notificationservice; do
  if [ -d "$dir" ]; then
    echo "Pulling $dir..."
    (cd "$dir" && git pull)
  fi
done

# Restart stack (use -p zoplanner so same volumes are always used, data persists)
cd zoplanner-api/webapi
docker-compose -p zoplanner down
docker-compose -p zoplanner up -d --build

echo "Done."
echo "Frontend: http://localhost:3000"
echo "Swagger - .NET: http://localhost:5027/swagger/index.html"
echo "Swagger - Java API: http://localhost:8080/swagger-ui/index.html"
echo "Swagger - Notification: http://localhost:8082/swagger-ui/index.html"
```

## Vad gör scriptet?

1. **Pullar alla 4 repos** – zoplanner-api, zoplanner-service, zoplanner-frontend, zoplanner-notificationservice
2. **Stoppar containrarna** – `docker-compose down`
3. **Bygger och startar om** – `docker-compose up -d --build`
4. **Visar länkar** – Frontend och alla Swagger-URL:er (.NET, Java API, Notification)

## Användning

Kör scriptet från **parent-mappen** där alla repos är klonade (samma nivå som zoplanner-api, zoplanner-service, etc.):

```bash
# Gör scriptet körbart (första gången)
chmod +x sync-and-start.sh

# Kör scriptet
./sync-and-start.sh
```

Om scriptet ligger i `zoplanner-infrastructure/`:

```bash
cd /path/to/ZoPlanner   # eller var dina repos ligger
./zoplanner-infrastructure/sync-and-start.sh
```

Eller kopiera scriptet till parent-mappen:

```bash
cp zoplanner-infrastructure/sync-and-start.sh .
chmod +x sync-and-start.sh
./sync-and-start.sh
```

## Databasen behålls

Scriptet använder `-p zoplanner` så att samma Docker-volym alltid används. Din databasdata behålls mellan körningar, även om du kör scriptet från olika mappar.

## Förutsättningar

- Alla 4 repos måste vara klonade i samma mapp
- Docker Desktop måste vara igång
- Du måste ha kört [START APP WITH DOCKER.md](./START%20APP%20WITH%20DOCKER.md) minst en gång (klona, .env, etc.)

## Efter körning

När scriptet är klart visas:

```
Done.
Frontend: http://localhost:3000
Swagger - .NET: http://localhost:5027/swagger/index.html
Swagger - Java API: http://localhost:8080/swagger-ui/index.html
Swagger - Notification: http://localhost:8082/swagger-ui/index.html
```
