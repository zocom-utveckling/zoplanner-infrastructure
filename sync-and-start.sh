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

echo "Done."
echo "Frontend: http://localhost:3000"
echo "Swagger - .NET: http://localhost:5027/swagger/index.html"
echo "Swagger - Java API: http://localhost:8080/swagger-ui/index.html"
echo "Swagger - Notification: http://localhost:8082/swagger-ui/index.html"
