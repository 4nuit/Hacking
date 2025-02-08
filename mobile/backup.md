# Memo

L'application de base (settings/backup) ne stocke pas les données des apps

## Doc

- https://gist.github.com/AnatomicJC/e773dd55ae60ab0b2d6dd2351eb977c1
- https://android.stackexchange.com/questions/250944/how-to-make-a-full-local-backup-of-my-phone

Pour les apps installés (pas présentes d'origine)

### Get apks

```bash
for APP in $(adb shell pm list packages -3 -f)
do
  adb pull $( echo ${APP} | sed "s/^package://" | sed "s/base.apk=/base.apk /").apk
done
```

### Backup app datas

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

### Backup base apps datas (photos ...)

```bash
adb pull -a /sdcard
```

### Restore apps

```bash
adb install application.apk
adb restore application.backup
```

