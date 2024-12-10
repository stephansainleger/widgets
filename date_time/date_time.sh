#!/bin/bash

# Récupération de la date et de l'heure actuelles
DATE=$(date +"%A %d %B %Y")
TIME=$(date +"%H:%M")

# Notification avec la date et l'heure
notify-send "$DATE, $TIME"
