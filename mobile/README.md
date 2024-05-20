## Doc

- https://github.com/randorisec/MobileHackingCheatSheet
- https://twitter.com/androidmalware2/status/1676884184424431616

### Android

- https://stackoverflow.com/questions/34482042/adb-backup-does-not-work (désactiver redmoon)
- https://gist.github.com/AnatomicJC/e773dd55ae60ab0b2d6dd2351eb977c1

```bash
#adb pull /data .
#adb backup -all -shared -noapk -system 

adb pull /sdcard .
adb backup -f all -all -apk -nosystem
adb restore backup.ab
```

**Utiliser FreeOTP+ -> Export key**

- https://www.apkmirror.com/
- https://forum.frandroid.com/topic/139590-tuto-adb-fastboot-drivers-root-recovery-backup-sans-toolkit/
- https://www.droidthunder.com/dc-unlocker/
- https://stackoverflow.com/questions/18533567/how-to-extract-or-unpack-an-ab-file-android-backup-file

**SAUVEGARDER SES DONNEES ET NE PAS TOUT DESINSTALLER**

- https://xdaforums.com/t/guide-emui-11-complete-debloating-guide-bloatware-list.4217323
- https://medium.com/purplebox/step-by-step-guide-to-building-an-android-pentest-lab-853b4af6945e
- https://connect.ed-diamond.com/misc/misc-116/un-edr-sous-android

### Ios

- https://andreafortuna.org/2020/08/31/ios-forensics-hfs-file-system-partitions-and-relevant-evidences/
- https://docs.google.com/spreadsheets/d/1z-44BUA2AVf8uqnoiDDSi7UxbyWy8KJqK4uaYq_0YYg/edit#gid=9
- https://connect.ed-diamond.com/MISC/misc-091/auditer-la-securite-d-une-application-ios-avec-needle
