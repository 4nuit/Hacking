# Stupid Twitch Booster "Analysis"


## Compiler [melter.cpp](https://github.com/pedro-lb/ScreenMelter/blob/master/ScreenMelter.cpp)

### Cross Compilation (Linux)

```bash
i686-w64-mingw32-g++ melter.cpp -o test.exe  -lgdi32 -static -static-libgcc -static-libstdc++
```

### Ajouter `msys-2.0.dll` (Windows)

```bash
#mingw
g++ melter.cpp -lgdi32 -static -static-libgcc -static-libstdc++ -o melter.exe
```

```bash
night@DESKTOP-THRLVRA MINGW32 ~
$ ldd ./melter.exe
        ntdll.dll => /c/Windows/SYSTEM32/ntdll.dll (0x7fff55250000)
        KERNEL32.DLL => /c/Windows/System32/KERNEL32.DLL (0x7fff532b0000)
        KERNELBASE.dll => /c/Windows/System32/KERNELBASE.dll (0x7fff52df0000)
        GDI32.dll => /c/Windows/System32/GDI32.dll (0x7fff53f50000)
        win32u.dll => /c/Windows/System32/win32u.dll (0x7fff53140000)
        gdi32full.dll => /c/Windows/System32/gdi32full.dll (0x7fff52a30000)
        msvcp_win.dll => /c/Windows/System32/msvcp_win.dll (0x7fff52b50000)
        ucrtbase.dll => /c/Windows/System32/ucrtbase.dll (0x7fff52930000)
        USER32.dll => /c/Windows/System32/USER32.dll (0x7fff54320000)
        msys-2.0.dll => /usr/bin/msys-2.0.dll (0x180040000)
```

## Hidden files

- https://support.microsoft.com/fr-fr/windows/voir-les-fichiers-et-les-dossiers-cach%C3%A9s-dans-windows-97fbc472-c603-9d90-91d0-1166d1d9f4b5

## Archive 

`Bat_To_Exe_Converter run.bat -> run.exe`
	- UAC : Request admin/user privileges
	- UPX : Enable compression
	- Extract: to Desktop
	- Possibilités d'ajouter une icone (.ico), décrire une version etc

`7zip -> Cocher SFX`

