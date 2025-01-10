#!/bin/bash

# Sets the screen colour temp using the `sct` tool based on local sunrise and sunset times

# call to get approximate location coordinates
ip_json_data=$(curl -s -S "https://ipinfo.io/json") > /dev/null
loc=$(jq -r '.loc' <<<"$ip_json_data")

LATITUDE=$(echo $loc | cut -d "," -f1)
LONGITUDE=$(echo $loc | cut -d "," -f2)

# call to get today's sunrise and sunset times
sunrisesunset_json_data=$(curl -s -S "https://api.sunrisesunset.io/json?lat=${LATITUDE}&lng=${LONGITUDE}&time_format=unix") > /dev/null

SUNRISE_LOCAL=$(jq -r '.results.sunrise' <<<"$sunrisesunset_json_data")
SUNSET_LOCAL=$(jq -r '.results.sunset' <<<"$sunrisesunset_json_data")

# Set screen color temp based on time
UNIX_TIME_NOW=$(date -u +%s)
if [ "$UNIX_TIME_NOW" -ge $SUNRISE_LOCAL ] && [ "$UNIX_TIME_NOW" -lt $SUNSET_LOCAL ]; then
    sct 6500  # daylight
else
    sct 3500  # night
fi

exit 0
