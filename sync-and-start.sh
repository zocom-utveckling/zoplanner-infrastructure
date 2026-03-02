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
