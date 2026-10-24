#!/bin/sh -ex

echo "[+] Initialize"
USER=$(whoami)
GDBINIT_PATH="/home/$USER/.gdbinit"
GEF_DIR="/home/$USER/.gef"
GEF_PATH="${GEF_DIR}/gef.py"


echo "[+] Check if another gef is installed"
if [ -e "${GEF_PATH}" ]; then
    echo "[-] ${GEF_PATH} already exists. Please delete or rename."
    echo "[-] INSTALLATION FAILED"
    exit 1
fi

echo "[+] Create .gef directory"
if [ ! -e "${GEF_DIR}" ]; then
    mkdir -p "${GEF_DIR}"
fi

echo "[+] Download gef"
wget -q https://raw.githubusercontent.com/bata24/gef/dev/gef.py -O "${GEF_PATH}"

echo "[+] Setup gef"
STARTUP_COMMAND="python sys.path.insert(0, \"${GEF_DIR}\"); from gef import *; Gef.main()"
if [ ! -e "${GDBINIT_PATH}" ] || [ -z "$(grep "from gef import" "${GDBINIT_PATH}")" ]; then
    echo "${STARTUP_COMMAND}" >> "${GDBINIT_PATH}"
fi

echo "[+] INSTALLATION SUCCESSFUL"
exit 0
