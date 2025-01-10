# sct-auto
Sets your screen colour temperature based on the sunset and sunrise times from your approximate geo-location.
Currently relies on two web services:
    - ipinfo.io for getting the local geo-location
    - sunrisesunset.io to get local sunrise and sunset times for today

### Background
Some Linux distributions do not have a built-in night mode or night light which allows to change your screen colour temp every night
to warmer colours making it easier on the eyes. I found the only program that works well in setting the colour temperature on the Linux 
disto that I use is called `sct` and it is very light-weight but does not have an automatic mode based on sunrise and sunset times.
Other programs such as `qredshift` do provide it but are more resource intensive and may introduce odd screen tearing every couple of seconds.
`sct-auto` wrapper script tries to expand `sct` making it more useful.

### Install dependencies
apt update && apt install curl jq sct -y

### Run
chmod +x sct-auto.sh
./sct-auto.sh

### Automation
As a further development, the script will download the list of future sunsrise & sunset times in a file once and 
all subsequent runs will read from the file eliminating the need to call the API every day. 
The script can be added to crontab to run once per day in order to automate the process of setting the screen temperature.

