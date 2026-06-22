## Device guides

- https://xdaforums.com/
- https://twrp.me/Devices/
- https://wiki.lineageos.org/devices/
- https://grapheneos.org/faq#supported-devices

## Tools

- [Android Firmware, Files & Tools - hovatek](https://www.hovatek.com/forum/forum-105.html)

## Backup

### SDcard

- https://drfone.wondershare.com/backup-android/how-to-backup-android-to-sd-card.html
- https://darwinsdata.com/how-do-i-backup-my-sd-card-before-formatting-my-phone/
- https://www.wikihow.com/Export-Contacts-on-Android

### ADB

The base **settings/backup** app does not store app's datas

- https://forum.frandroid.com/topic/139590-tuto-adb-fastboot-drivers-root-recovery-backup-sans-toolkit/
- https://stackoverflow.com/questions/18533567/how-to-extract-or-unpack-an-ab-file-android-backup-file

- https://stackoverflow.com/questions/34482042/adb-backup-does-not-work (stop redmoon)
- https://gist.github.com/AnatomicJC/e773dd55ae60ab0b2d6dd2351eb977c1
- https://android.stackexchange.com/questions/250944/how-to-make-a-full-local-backup-of-my-phone


#### Get installed apks

```bash
for APP in $(adb shell pm list packages -3 -f)
do
  adb pull $( echo ${APP} | sed "s/^package://" | sed "s/base.apk=/base.apk /").apk
done
```

#### Backup app datas

```bash
adb backup -f all -all -apk -nosystem
```

or

```bash
for APP in $(adb shell pm list packages -3)
do
  APP=$( echo ${APP} | sed "s/^package://")
  adb backup -f ${APP}.backup ${APP}
done
```

#### Backup base apps datas (photos ...)

```bash
adb pull -a /sdcard
```

#### Restore apps

```bash
adb install application.apk
adb restore application.backup
```
