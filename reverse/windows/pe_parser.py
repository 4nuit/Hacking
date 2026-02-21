#!/usr/bin/python
import pefile

import os
import sys

if len(sys.argv) != 2:
    print("Usage: python3 your_script.py <path_to_file>")
    sys.exit(1)

PATH_TO_FILE = os.path.abspath(sys.argv[1])
pe = pefile.PE(PATH_TO_FILE)

def returncopyright(pe):
	if hasattr(pe, 'VS_VERSIONINFO'):
		for idx in range(len(pe.VS_VERSIONINFO)):
			if hasattr(pe, 'FileInfo') and len(pe.FileInfo) > idx:
				for entry in pe.FileInfo[idx]:
					if hasattr(entry, 'StringTable'):
						for st_entry in entry.StringTable:
							for str_entry in sorted(list(st_entry.entries.items())):
								if "LegalCopyright" in str_entry[0].decode('utf-8', 'backslashreplace'):
									return str_entry[1].decode('utf-8', 'backslashreplace')
	return "No copyright found"

copyright = returncopyright(pe) ; print(copyright)
