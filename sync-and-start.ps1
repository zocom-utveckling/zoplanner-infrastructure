<# 
 Script to sync all ZoPlanner repos and restart the Docker stack on Windows (PowerShell).
 Run this from the parent folder where all repos (zoplanner-api, zoplanner-service, etc.) live.
#>

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

Write-Host "Done."
Write-Host "Frontend: http://localhost:3000"
Write-Host "Swagger - .NET: http://localhost:5027/swagger/index.html"
Write-Host "Swagger - Java API: http://localhost:8080/swagger-ui/index.html"
Write-Host "Swagger - Notification: http://localhost:8082/swagger-ui/index.html"

