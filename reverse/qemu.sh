#!/bin/bash

set -e -o pipefail

RAM=256M

if ! which qemu-system-mipsel >/dev/null \
|| ! which qemu-system-ppc >/dev/null \
|| ! which qemu-system-arm >/dev/null \
|| ! which qemu-system-i386 >/dev/null \
|| ! which qemu-system-x86_64 >/dev/null
then
 if "$(uname -s)" = "Darwin"
 then
  echo "brew install qemu"
  brew install qemu
 elif "$(uname -s)" = "Linux"
 then
  echo "sudo apt-get install qemu qemu-system"
  sudo apt-get install qemu qemu-system
 else
  echo "Error: please install qemu" >&2
  exit 1
 fi
fi

function notes {
 echo "Notes:"
 echo "- The root account password is 'root'"
 echo "- There is a user account named 'user' with password 'user'"
 echo "- Port 22 is port-forwarded to 2222, try 'ssh -p 2222 user@localhost'"
}

if test "$1" = "mips" -o "$1" = "mipsel"
then
 mkdir -p ~/.qemu.sh/wheezy/mipsel
 cd ~/.qemu.sh/wheezy/mipsel
 test -e debian_wheezy_mipsel_standard.qcow2 \
  || wget https://people.debian.org/~aurel32/qemu/mipsel/debian_wheezy_mipsel_standard.qcow2
 test -e vmlinux-3.2.0-4-4kc-malta \
  || wget https://people.debian.org/~aurel32/qemu/mipsel/vmlinux-3.2.0-4-4kc-malta
 notes
 qemu-system-mipsel \
  -m $RAM \
  -M malta -kernel vmlinux-3.2.0-4-4kc-malta \
  -hda debian_wheezy_mipsel_standard.qcow2 \
  -net nic -net user,hostfwd=tcp::2222-:22 \
  -append "root=/dev/sda1 console=tty0" \
  -no-reboot

elif test "$1" = "ppc" -o "$1" = "powerpc"
then
 mkdir -p ~/.qemu.sh/wheezy/powerpc
 cd ~/.qemu.sh/wheezy/powerpc
 test -e debian_wheezy_powerpc_standard.qcow2 \
  || wget https://people.debian.org/~aurel32/qemu/powerpc/debian_wheezy_powerpc_standard.qcow2
 notes
 qemu-system-ppc \
  -m $RAM \
  -hda debian_wheezy_powerpc_standard.qcow2 \
  -net nic -net user,hostfwd=tcp::2222-:22 \
  -no-reboot

elif test "$1" = "arm" -o "$1" = "armel"
then
 mkdir -p ~/.qemu.sh/wheezy/armel
 cd ~/.qemu.sh/wheezy/armel
 test -e debian_wheezy_armel_standard.qcow2 \
  || wget https://people.debian.org/~aurel32/qemu/armel/debian_wheezy_armel_standard.qcow2
 test -e initrd.img-3.2.0-4-versatile \
  || wget https://people.debian.org/~aurel32/qemu/armel/initrd.img-3.2.0-4-versatile
 test -e vmlinuz-3.2.0-4-versatile \
  || wget https://people.debian.org/~aurel32/qemu/armel/vmlinuz-3.2.0-4-versatile
 notes
 qemu-system-arm \
  -m $RAM \
  -M versatilepb -kernel vmlinuz-3.2.0-4-versatile \
  -initrd initrd.img-3.2.0-4-versatile \
  -hda debian_wheezy_armel_standard.qcow2 \
  -net nic -net user,hostfwd=tcp::2222-:22 \
  -append "root=/dev/sda1"

elif test "$1" = "x86" -o "$1" = "i386"
then
 mkdir -p ~/.qemu.sh/wheezy/i386
 cd ~/.qemu.sh/wheezy/i386
 test -e debian_wheezy_i386_standard.qcow2 \
  || wget https://people.debian.org/~aurel32/qemu/i386/debian_wheezy_i386_standard.qcow2
 notes
 qemu-system-i386 \
  -m $RAM \
  -hda debian_wheezy_i386_standard.qcow2 \
  -net nic -net user,hostfwd=tcp::2222-:22

elif test "$1" = "x64" -o "$1" = "x86_64" -o "$1" = "amd64"
then
 mkdir -p ~/.qemu.sh/wheezy/amd64
 cd ~/.qemu.sh/wheezy/amd64
 test -e debian_wheezy_amd64_standard.qcow2 \
  || wget https://people.debian.org/~aurel32/qemu/amd64/debian_wheezy_amd64_standard.qcow2
 notes
 qemu-system-x86_64 \
  -m $RAM \
  -hda debian_wheezy_amd64_standard.qcow2 \
  -net nic -net user,hostfwd=tcp::2222-:22

else
 echo "Error: unknown architecture " $1 >&2
 echo "Please specify one of mips|ppc|arm|x86|x64" >&2
 exit 1
fi
