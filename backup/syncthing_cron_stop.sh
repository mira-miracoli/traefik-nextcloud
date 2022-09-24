#!/bin/bash

# SCRIPT TO STOP SYNCTHING

## STOP SYNCTHING
  systemctl stop syncthing@ubuntu.service

## MOUNT
  umount /dev/backup/pi

