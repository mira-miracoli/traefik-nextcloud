#!/bin/bash
cd /home/ubuntu/docker
/home/ubuntu/.local/bin/docker-compose pull
/home/ubuntu/.local/bin/docker-compose up --force-recreate --build -d
/usr/bin/docker image prune -f

