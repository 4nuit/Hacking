# Android Pentest cheatsheet  - https://mobisec.reyammer.io/

## Install split apk

```bash
adb install base.apk
adb push split-config* /data/app/com.packagename/
adb shell pm install -p <package-name> split-configXXX.apk
```

## Install burp CA on emulator

- https://github.com/niklashigi/apk-mitm

**dl burp certificate**

```bash
openssl x509 -inform DER -in cacert.der -out cacert.pem
openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1
mv cacert.pem <hash>.0
```

**start emulator with** `-writable-system` option

```bash
adb root && adb remount
adb push 9a5ba575.0 /sdcard/
adb shell mv /sdcard/9a5ba575.0 /system/etc/security/cacerts/
adb shell chmod 644 /system/etc/security/cacerts/9a5ba575.0
adb reboot
```

## Clear text / Easy wins

```bash
grep for "secret" "key" "api" in res/strings.xml
find . -name "BuildConf*" -exec cat {} + => find and cat all buildConfig files
grep -iR -F "getRuntime().exec" <decompiled apk>
```

## Dynamic reversing / injecting

### frida

```bash
$ adb push frida-server /data/local/tmp/
$ adb shell "chmod 755 /data/local/tmp/frida-server"
$ adb shell "/data/local/tmp/frida-server &"
```

==> test connection with frida-ps -U

### drozer

install drozer-agent.apk 

```bash
adb forward tcp:31415 tcp:31415
```

==> drozer console connect

### RMS-mobile-sec

```bash
python3 RMS-mobile...
connect to localhost:5000
````

