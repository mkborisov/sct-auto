#!/bin/bash

# Sets the screen colour temp automatically based on your local sunrise and sunset times

DATE_TODAY=$(date +%Y-%m-%d) # yyyy-mm-dd
UNIX_TIME_NOW=$(date -u +%s)
LOC_FILE=.data/current_location
SUN_TIMES_FILE=.data/sun_times

get_location () {
    mkdir -p .data
    # call to get approximate location coordinates
    ip_json_data=$(curl -s -S "https://ipinfo.io/json") > /dev/null
    loc=$(jq -r '.loc' <<<"$ip_json_data")
    
    echo $loc > $LOC_FILE
    get_sun_times
}

get_sun_times () {
    # call to get today's sunrise and sunset times
    lat=$(cat $LOC_FILE | cut -d "," -f1)
    lon=$(cat $LOC_FILE | cut -d "," -f2)
    sunrisesunset_json_data=$(curl -s -S "https://api.sunrisesunset.io/json?lat=${lat}&lng=${lon}&time_format=unix") > /dev/null
    sunrise=$(jq -r '.results.sunrise' <<<"$sunrisesunset_json_data")
    sunset=$(jq -r '.results.sunset' <<<"$sunrisesunset_json_data")
    dawn=$(jq -r '.results.dawn' <<<"$sunrisesunset_json_data")
    dusk=$(jq -r '.results.dusk' <<<"$sunrisesunset_json_data")

    echo "$sunrise,$sunset,$dawn,$dusk" > $SUN_TIMES_FILE
}

if ! [ -s "$LOC_FILE" ]; then
    # file not present or is empty so get the location
    get_location
fi

if [ "$DATE_TODAY" != $(date -r $LOC_FILE +%Y-%m-%d) ]; then
    echo "date today not equal to date modified so refresh the data"
    get_location
fi

SUNRISE_LOCAL=$(cat $SUN_TIMES_FILE | cut -d "," -f1)
SUNSET_LOCAL=$(cat $SUN_TIMES_FILE | cut -d "," -f2)
DAWN_LOCAL=$(cat $SUN_TIMES_FILE | cut -d "," -f3)
DUSK_LOCAL=$(cat $SUN_TIMES_FILE | cut -d "," -f4)

# Set screen color temp based on time
if [ "$UNIX_TIME_NOW" -ge $DAWN_LOCAL ] && [ "$UNIX_TIME_NOW" -lt $SUNRISE_LOCAL ]; then
    sct 5000  # dawn
elif [ "$UNIX_TIME_NOW" -ge $SUNRISE_LOCAL ] && [ "$UNIX_TIME_NOW" -lt $SUNSET_LOCAL ]; then
    sct 6500  # daylight
elif [ "$UNIX_TIME_NOW" -ge $SUNSET_LOCAL ] && [ "$UNIX_TIME_NOW" -lt $DUSK_LOCAL ]; then
    sct 4500  # dusk
else
    sct 3500  # night
fi

exit 0