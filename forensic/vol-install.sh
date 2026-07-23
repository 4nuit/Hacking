#!/bin/bash

set -e

# Fancy output
BLUE="\033[36m"
RED="\033[31m"
GREEN="\033[32m"
RESET="\033[0m"

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
INSTALL_DIR_2=${INSTALL_DIR}/volatility2
INSTALL_DIR_3=${INSTALL_DIR}/volatility3
VOLATILITY_2_REPO="${VOLATILITY_2_REPO:-https://github.com/volatilityfoundation/volatility.git}"
VOLATILITY_3_REPO="${VOLATILITY_3_REPO:-https://github.com/volatilityfoundation/volatility3.git}"

if ! git --version &> /dev/null
then
	echo -e "${RED}Git is not installed, cannot continue${RESET}"
	exit 1
fi


function setupPythonVersion() {

	major=$(echo $1 | cut -d. -f1)
	minor=$(echo $1 | cut -d. -f2)

	# Try using Pyenv
	if pyenv --version &> /dev/null
	then
		echo -e "${GREEN}Will use Pyenv to setup Python ${BLUE}$1${RESET}" >&2
		pyenv install -s $1 >&2
		stub="$(pyenv prefix $1)/bin/python"
		echo -e "${GREEN}Will be using Pyenv-managed Python ${BLUE}$1${GREEN} at ${BLUE}$stub${GREEN} to provide Python ${BLUE}$1${GREEN}.${RESET}" >&2
		echo $stub
		return 0
	fi
	
	stub="python$major"
	if $stub --version &> /dev/null
	then
		stub="$(which $stub)"
		stubVersion="$($stub --version | cut -d' ' -f2)"
		stubMajor="$(echo $stubVersion | cut -d. -f1)"
		stubMinor="$(echo $stubVersion | cut -d. -f2)"
		if [[ "$stubMajor" -eq "$major" ]] && [[ "$stubMinor" -ge "$minor" ]]
		then
			echo -e "${GREEN}Will be using Python ${BLUE}$stubVersion${GREEN} at ${BLUE}$stub${GREEN} to provide Python ${BLUE}$1${GREEN}.${RESET}" >&2
			echo "$stub"
			return 0
		fi
	fi
	
	stub="python"
	if $stub --version &> /dev/null
	then
		stub="$(which $stub)"
		stubVersion="$($stub --version | cut -d' ' -f2)"
		stubMajor="$(echo $stubVersion | cut -d. -f1)"
		stubMinor="$(echo $stubVersion | cut -d. -f2)"
		if [[ "$stubMajor" -eq "$major" ]] && [[ "$stubMinor" -ge "$minor" ]]
		then
			echo -e "${GREEN}Will be using Python ${BLUE}$stubVersion${GREEN} at ${BLUE}$stub${GREEN} to provide Python ${BLUE}$1${GREEN}.${RESET}" >&2
			echo "$stub"
			return 0
		fi
	fi

	echo -e "${RED}Could not find a suitable version for Python ${BLUE}$1${RED}. Cannot continue. Either install Python ${BLUE}$1${RED} or setup ${BLUE}Pyenv${RED}.${RESET}" >&2
	exit 1

}


if ! python3=$(setupPythonVersion 3.9)
then
	exit
fi

if ! python2=$(setupPythonVersion 2.7)
then
	exit
fi

mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}Will be installing to ${BLUE}$INSTALL_DIR${RESET}"
if ! echo $PATH | grep "$INSTALL_DIR" &> /dev/null
then
	echo -e "${RED}WARNING: Installation directory not in PATH.${RESET}"
fi

function clone() {
	if [[ -d "$3/.git" ]]
	then
		echo -e "${GREEN}$3${BLUE} already exists, pulling...${RESET}"
		pushd $3 &> /dev/null
		git pull
		popd &> /dev/null
	else
		echo -e "${BLUE}Cloning volatility $1 from ${GREEN}$2${BLUE}...${RESET}" 
		git clone "$2" "$3"
	fi
}

clone 2 "$VOLATILITY_2_REPO" "$INSTALL_DIR_2"
clone 3 "$VOLATILITY_3_REPO" "$INSTALL_DIR_3"

echo -e "${BLUE}Setting up environment for Volatility 2...${RESET}"
pushd "$INSTALL_DIR_2" &> /dev/null
if [[ -d venv ]]
then
	echo -e "${RED}Removing existing virtual environment.${RESET}"
	rm -R venv
fi
echo -e "${BLUE}Installing virtualenv...${RESET}"
$python2 -m pip install virtualenv
$python2 -m virtualenv venv
source venv/bin/activate
echo -e "${GREEN}Now working in virtual python environment: ${GREEN}$(which python)${RESET}"
echo -e "${BLUE}Installing volatility dependencies...${RESET}"
python -m pip install pycryptodome yara-python distorm3
deactivate
popd &> /dev/null
echo -e "${BLUE}Dropping vol2 script...${RESET}"
cat > "$INSTALL_DIR/vol2" << EOF
#!/bin/bash
source $INSTALL_DIR_2/venv/bin/activate
python $INSTALL_DIR_2/vol.py "\$@"
deactivate
EOF
chmod +x "$INSTALL_DIR/vol2"
echo -e "${GREEN}Volatility 2 was installed succesfully, invoke it with ${BLUE}vol2${RESET}"


echo -e "${BLUE}Setting up environment for Volatility 3...${RESET}"
pushd "$INSTALL_DIR_3" &> /dev/null
if [[ -d venv ]]
then
	echo -e "${RED}Removing existing virtual environment.${RESET}"
	rm -R venv
fi
$python3 -m venv venv
source venv/bin/activate
echo -e "${GREEN}Now working in virtual python environment: ${GREEN}$(which python)${RESET}"
echo -e "${BLUE}Installing volatility dependencies...${RESET}"
python -m pip install -r requirements.txt
deactivate
popd &> /dev/null
echo -e "${BLUE}Dropping vol3 script...${RESET}"
cat > "$INSTALL_DIR/vol3" << EOF
#!/bin/bash
source $INSTALL_DIR_3/venv/bin/activate
python $INSTALL_DIR_3/vol.py "\$@"
deactivate
EOF
chmod +x "$INSTALL_DIR/vol3"
echo -e "${GREEN}Volatility 3 was installed succesfully, invoke it with ${BLUE}vol3${RESET}"
