# sct-auto
Sets your screen colour temperature based on the sunset and sunrise times from your approximate geo-location.
Currently relies on two web services:
    - ipinfo.io for getting your geo-location
    - sunrisesunset.io to get local sunrise and sunset times for today

### Background
Some Linux distributions do not have a built-in night mode or night light which allows to change your screen colour temp every night to warmer colours making it easier on the eyes. `sct` short for screen colour temperature allows that but does not have an automatic mode based on sunrise and sunset times.
Other programs such as `qredshift` do provide it but are more resource intensive and may introduce odd screen tearing every couple of seconds.

### Install dependencies
```sh
apt update && apt install curl jq sct -y
```

### Run
```sh
chmod +x sct-auto.sh
./sct-auto.sh
```

### Automation
The script will store your location with the local sunsrise & sunset times in a file and update the data once a day.
The script can be added to crontab to run every half hour in order to automate the process of setting the screen temperature.

```sh
crontab -e
*/30 * * * * /repo-path/sct-auto.sh
```

### Tweaks
`sct` sets the screen's color temperature in a range from 1000 to 10000 using the Kelvin scale. You can edit the default values in the script to your own preference.

### References
https://manpages.ubuntu.com/manpages/bionic/en/man1/sct.1.html
https://ipinfo.io/
https://sunrisesunset.io/
