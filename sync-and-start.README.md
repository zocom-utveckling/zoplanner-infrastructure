# sync-and-start.sh

Script för att synka alla ZoPlanner-repos och starta om Docker-stacken efter att någon har pushat ändringar.

## Ladda ner alla repo första gången

```bash
# Skapa en mapp för projektet
mkdir ZoPlanner
cd ZoPlanner

git clone https://github.com/zocom-utveckling/zoplanner-api.git
git clone https://github.com/zocom-utveckling/zoplanner-service.git
git clone https://github.com/zocom-utveckling/zoplanner-frontend.git
git clone https://github.com/zocom-utveckling/zoplanner-notificationservice

```

## Scriptet 

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

# Restart stack
cd zoplanner-api/webapi
docker-compose down
docker-compose up -d --build

echo "Done. Frontend: http://localhost:3000 | .NET: http://localhost:5027 | Java: http://localhost:8080"
```

## Vad gör scriptet?

1. **Pullar alla 4 repos** – zoplanner-api, zoplanner-service, zoplanner-frontend, zoplanner-notificationservice
2. **Stoppar containrarna** – `docker-compose down`
3. **Bygger och startar om** – `docker-compose up -d --build`
4. **Visar länkar** – Frontend, .NET och Java-URL:er

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

## Förutsättningar

- Alla 4 repos måste vara klonade i samma mapp
- Docker Desktop måste vara igång
- Du måste ha kört [START APP WITH DOCKER.md](./START%20APP%20WITH%20DOCKER.md) minst en gång (klona, .env, etc.)

## Efter körning

När scriptet är klart visas:

```
Done. Frontend: http://localhost:3000 | .NET: http://localhost:5027 | Java: http://localhost:8080
```
