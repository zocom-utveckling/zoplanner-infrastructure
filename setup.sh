#!/bin/sh
set -e

cd "$HOME/Desktop"
timestamp=$(date +"%d-%m-%y_%H.%M.%S")
folderName="zoplanner_$timestamp"

mkdir "$folderName" && cd "$folderName"

git clone https://github.com/zocom-utveckling/zoplanner-api.git 
git clone https://github.com/zocom-utveckling/zoplanner-service.git
git clone https://github.com/zocom-utveckling/zoplanner-frontend.git
git clone https://github.com/zocom-utveckling/zoplanner-notificationservice.git
 

echo "Please add .env file with credentials inside ./zoplanner-api/webapi before proceeding. Press ENTER to continue."
read

if command -v docker-compose >/dev/null 2>&1; then
    dockerc="docker-compose"
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
   	dockerc="docker compose"
else
    echo "Error: Docker Compose not found."
    exit 1
fi

cd ./zoplanner-api/webapi

$dockerc -p zoplanner down --remove-orphans
$dockerc -p zoplanner up -d --build
