#!/bin/bash
docker compose exec -u 33 nextcloud php occ app:install memories
docker compose exec -u 33 nextcloud php occ app:install previewgenerator
docker compose exec -u 33 nextcloud php occ app:install recognize
docker compose exec -u 33 nextcloud php occ app:install facerecognition

# docker compose exec -u 33 nextcloud php occ config:system:set filelocking.enabled --value=false