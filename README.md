# zoplanner-infrastructure

Infrastructure and deployment guides for the ZoPlanner system.

## Quick sync script

After someone pushes changes, run this from the parent folder (where all repos are cloned):

```bash
./sync-and-start.sh
```

Or manually:

```bash
chmod +x sync-and-start.sh
./sync-and-start.sh
```

The script pulls all 4 repos, runs `docker-compose down`, then `docker-compose up -d --build`.

---

# 🚀 ZoPlanner: Starta 5 containrar Guide

> **Komplett guide för att starta hela ZoPlanner-systemet med Docker**  

---

## 📚 Relaterade Repositories och Dokumentation

### Repositories

| Repository | Beskrivning | Länk |
|-----------|-------------|------|
| **zoplanner-api** | CRUD API mot databasen (Java/Spring Boot) | [GitHub](https://github.com/zocom-utveckling/zoplanner-api) |
| **zoplanner-service** | Backend-tjänst (.NET) | [GitHub](https://github.com/zocom-utveckling/zoplanner-service) |
| **zoplanner-frontend** | Användargränssnitt (Frontend) | [GitHub](https://github.com/zocom-utveckling/zoplanner-frontend) |
| **zoplanner-notificationservice** | Notifikationsservice (Java) | [GitHub](https://github.com/zocom-utveckling/zoplanner-notificationservice) |

### Befintlig Dokumentation

- 📖 [README.md](./README.md) - Detaljerad guide för utvecklare (databas setup, IntelliJ, Swagger, CI/CD)
- 🐳 [DOCKER_INSTRUCTIONS.md](./webapi/DOCKER_INSTRUCTIONS.md) - Detaljerade Docker-kommandon och nätverksarkitektur
- [HUR KOPPLAS SPRING BOOT OCH >NET](https://github.com/zocom-utveckling/zoplanner-service/blob/dev/README.md)

---

## 🏗️ Systemöversikt

ZoPlanner består av **5 Docker-containrar** som kommunicerar med varandra:

```
┌─────────────────────────────┐
│         Frontend            │
│   (zoplanner-frontend)      │
│   Port: 3000                │
└─────────────┬───────────────┘
              │ beroende av
              ▼
┌─────────────────────────────┐
│       .NET-tjänst           │
│  (zoplanner-dotnet)         │
│  Port: 5027                 │
│  SpringApi__BaseUrl ->      │
│  http://zoplanner:8080/api  │
└─────────────┬───────────────┘
              │ beroende av
              ▼
┌─────────────────────────────┐     ┌─────────────────────────────┐
│   Spring Boot-app           │     │  Notification Service       │
│   (zoplanner)               │     │  (zoplanner-notification)   │
│   Port: 8080                │     │  Port: 8082                 │
└─────────────┬───────────────┘     └─────────────┬───────────────┘
              │ beroende av                       │ beroende av
              │                                   │
              └──────────────┬────────────────────┘
                             ▼
              ┌─────────────────────────────┐
              │     PostgreSQL-databas      │
              │   (zoplanner-database)      │
              │   Port: 5432                │
              └─────────────────────────────┘

Alla containrar är anslutna till samma nätverk `zoplanner` (bridge), så de kan kommunicera med varandra via container-namn.

```

| Container | Beskrivning | Port |
|-----------|-------------|------|
| **zoplanner-database** | PostgreSQL databas | `localhost:5432` |
| **zoplanner** | Spring Boot API (Java) | `localhost:8080` |
| **zoplanner-dotnet** | .NET Service | `localhost:5027` |
| **zoplanner-frontend** | Frontend applikation | `localhost:3000` |
| **zoplanner-notificationservice** | Notification Service | `localhost:8082` |

---

## ✅ Förutsättningar - Vad behöver jag installera?

Innan du börjar, installera följande program:

### 1. Docker Desktop (KRÄVS)
- 📥 **Ladda ner:** [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- ✅ Installera och starta Docker Desktop
- 🔍 Verifiera installation: Öppna terminal och kör `docker --version`
- ☝️ Man behöver skapa ett konto eller logga in
> Om du skapar ett konto för första gången måste du verifiera din e-postadress med hjälp av länken som skickas till din e-postadress, annars kommer du att få problem med att starta applikationen.

### 2. Git (KRÄVS)
- 📥 **Ladda ner:** [https://git-scm.com/downloads](https://git-scm.com/downloads)
- ✅ Installera Git
- 🔍 Verifiera installation: Öppna terminal och kör `git --version`

### 3. Maven och Java JDK 21 (KRÄVS)
Windows
1. Öppna CMD som administratör

2. Starta PowerShell från CMD (eller starta PowerShell direct utan CMD)

```
powershell
```

Nu kan du köra PowerShell-kommandon direkt i CMD.

3. Tillåt att skript körs

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```
Detta behövs för att kunna installera Scoop.

4. Installera Scoop

```
iwr -useb get.scoop.sh | iex
```

Scoop installerar sig själv och uppdaterar PATH automatiskt.

5. Installera Maven

```
scoop install maven
```

6. Lägg till Java-bucket

```
scoop bucket add java
```

7. Installera Java 21

```
scoop install openjdk21
```

Detta installerar Java 21 och sätter JAVA_HOME automatiskt.

8. Kontrollera Java

```
java -version
```

9. Kontrollera Maven

```
mvn -v
```

### 7. För utveckling (men man kan starta hela systemet utan det)
- **IntelliJ IDEA** - Rekommenderad IDE för Java-utveckling - våra inskruktioner [https://github.com/zocom-utveckling/zoplanner-api/blob/dev/README.md#hur-man-laddar-ner-och-k%C3%B6r-repot-i-intellij-idea](https://github.com/zocom-utveckling/zoplanner-api/blob/dev/README.md#hur-man-laddar-ner-och-kör-repot-i-intellij-idea)
- **Visual Studio Code** - För .Net och React

---

## 🎯 Snabbstart - Starta systemet (Steg-för-steg)

### Steg 1: Klona alla repositories

Öppna en terminal (CMD, PowerShell, eller Terminal på Mac) och kör:

```bash
# Skapa en mapp för projektet
mkdir ZoPlanner
cd ZoPlanner

# Klona alla fyra repositories
# När man kör det här kommandot öppnas ett fönster där man behöver logga in på GitHub. Följ instruktionerna. 
# Man måste logga in med ett konto som har åtkomst till alla repo som man klonar.

git clone https://github.com/zocom-utveckling/zoplanner-api.git
git clone https://github.com/zocom-utveckling/zoplanner-service.git
git clone https://github.com/zocom-utveckling/zoplanner-frontend.git
git clone https://github.com/zocom-utveckling/zoplanner-notificationservice
```

### Steg 2: Skapa miljövariabler (.env fil)

Navigera till `zoplanner-api/webapi` mappen och skapa en fil som heter `.env`:

```bash
cd zoplanner-api/webapi
```

### Skapa filen `.env` 

Windows

```
# Alternativ A – via PowerShell
New-Item -Path .env -ItemType File

# Alternativ B – via vanlig CMD
type nul > .env

# Kontrollera innehållet
notepad .env

# Notepad öppnas – klistra in följande:

HOST=zoplanner-database
PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=test123
POSTGRES_DB=zoplanner
AWS_ACCESS_KEY_ID=your_actual_access_key_id
AWS_SECRET_ACCESS_KEY=your_actual_secret_access_key
AWS_REGION=eu-north-1
SQS_QUEUE_URL=https://sqs.eu-north-1.amazonaws.com/your-account-id/zoplanner-notifications

# Spara filen → stäng Notepad.

```

> ⚠️ **VIKTIGT:** Kommittera ALDRIG denna fil till Git!

### (OBS, följande steg behövs ej om du följt guiden rakt av, gå direkt till steg 4)
### Steg 3: Konfigurera sökvägar i docker-compose.yml 

Öppna filen `zoplanner-api/webapi/docker-compose.yml` och uppdatera sökvägarna till .NET-tjänsten och frontend:

```yaml
# Ändra denna rad för .NET-tjänsten:
context: ./path/to/dotnet-service
# Till din faktiska sökväg, t.ex. (om repos ligger i samma mapp):
context: ../../zoplanner-service/zoplannerservice

# Ändra denna rad för frontend:
context: ./path/to/frontend
# Till din faktiska sökväg, t.ex. (om repos ligger i samma mapp):
context: ../../zoplanner-frontend

# Ändra denna rad för notification-service tjänsten:
context: .path/to/zoplanner-notificationservice 
# Till din faktiska sökväg, t.ex. (om repos ligger i samma mapp):
context: ../../zoplanner-notificationservice
```

> 💡 **Tips:** Sökvägarna beror på var du har klonat repositories. Om alla tre repos ligger i samma mapp (`ZoPlanner/`), använd `../../` för att gå två nivåer upp från `webapi/`-mappen.


### Steg 4: Starta alla containers - Starta Docker Desctop innan du ska använda en kommando!

```bash
# Starta alla 5 containers (från zoplanner-api/webapi mappen)
docker-compose up -d --build
```

### Steg 5: Verifiera att allt fungerar

- 🌐 Öppna **Frontend**: [http://localhost:3000](http://localhost:3000)
- 🔌 Öppna **Spring Boot API (Swagger)**: [http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)
- 🔌 Öppna **.NET Service**: [http://localhost:5027/swagger/index.html](http://localhost:5027/swagger/index.html)

---

## 📋 Snabbreferens - Vanliga kommandon

| Åtgärd | Kommando |
|--------|----------|
| **Starta alla containers** | `docker-compose up -d` |
| **Starta med rebuild** | `docker-compose up -d --build` |
| **Stoppa alla containers** | `docker-compose down` |
| **Stoppa och radera data** | `docker-compose down -v` |
| **Se status** | `docker-compose ps` |
| **Se loggar** | `docker-compose logs -f` |
| **Starta om alla** | `docker-compose restart` |
| **Lägg till data manuelt i databasen** | `docker exec -it din-container-namn psql -U postgres -d zoplanner -c "skriv sql kodan här"` |
| **Lägg till data manuelt från fil** | `docker cp uppdatering.sql din-container-namn:/tmp/` |
| **Kör filen** | `docker exec -it din-container-namn psql -U postgres -d ditt-db-namn -f /tmp/uppdatering.sql` |

### Starta enskilda containers

```bash
# Endast databasen
docker-compose up -d zoplanner-database

# Endast Spring Boot API
docker-compose up -d app

# Endast .NET Service
docker-compose up -d dotnet-service

# Endast Frontend
docker-compose up -d frontend

# Endast Notification service
docker-compose up -d notification-service
```

---

## 🔧 Felsökning

### "Docker is not running"
- ✅ Starta Docker Desktop och vänta tills ikonen blir grön

### "Port already in use"
- ✅ Stäng andra program som använder portarna (5432, 8080, 5027, 3000)
- ✅ Eller kör `docker-compose down` om tidigare containers körs

### "Cannot find .env file"
- ✅ Skapa `.env` filen enligt instruktionerna i Steg 2

### "Build failed"
- ✅ Kontrollera att du har rätt sökvägar i `docker-compose.yml`
- ✅ Kontrollera loggarna med `docker-compose logs`

### Se detaljerade loggar för specifik container
```bash
docker-compose logs -f app          # Spring Boot
docker-compose logs -f dotnet-service  # .NET
docker-compose logs -f zoplanner-database  # Databas
docker-compose logs -f frontend     # Frontend
```

## 🆘 Behöver du hjälp?

Om du stöter på problem:

1. 📖 Läs igenom felsökningsavsnittet ovan
2. 📋 Kontrollera loggarna med `docker-compose logs -f`
3. 💬 Kontakta utvecklingsteamet i discord


### OBS, utdaterad data. Det finns fler tabeller och kolumner i databasen idag. Databasen skapas automatiskt via Java CRUD API-koden om det inte finns en databas på datorn. För att uppdatera databasen krävs i nuläget att man manuellt tart bort den gamla från PgAdmin.

---

## Testdata till databasen

Se [zoplanner-api START APP WITH DOCKER.md](https://github.com/zocom-utveckling/zoplanner-api/blob/dev/START%20APP%20WITH%20DOCKER.md) för fullständig SQL-testdata.
