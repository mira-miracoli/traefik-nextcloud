#!/bin/bash

# SCRIPT TO START SYNCTHING

## MOUNT
  mount /dev/backup/pi /media/backup

## START SYNCTHING
  systemctl start syncthing@ubuntu.service
