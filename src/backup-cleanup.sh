#!/bin/bash

if [ ! -d ./monthly ]; then
	mkdir ./monthly
fi

# Make a copy of the  last backup to the monthly folder

ls -1t spaceman_data* | head -1 | xargs -I % cp % monthly
ls -1t sciencia_data* | head -1 | xargs -I % cp % monthly

# Keep the last 7 backups for each app

ls -1t spaceman_data* | tail -n +8 | xargs rm -f
ls -1t sciencia_data* | tail -n +8 | xargs rm -f
