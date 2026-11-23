#!/usr/bin/python3
import re

with open("module.dwarf","r") as f:
    content = f.read()

def hex8(match):
    val_str = match.group(1)
    val = int(val_str, 16) if val_str.startswith('0x') else int(val_str)
    return f'DW_AT_byte_size<{val}>'
content = re.sub(r'DW_AT_byte_size<(0x[0-9a-fA-F]+|[0-9]+)(?:\s*\([^)]*\))?>',hex8,content)

def dec_loc(match):
    val_str = match.group(1)
    val = int(val_str, 16) if val_str.startswith('0x') else int(val_str)
    return f'DW_AT_data_member_location<{val}>'
content = re.sub(r'DW_AT_data_member_location<(0x[0-9a-fA-F]+|[0-9]+)(?:\s*\([^)]*\))?>',dec_loc,content)

content = re.sub(r' Refers to: [^>]*>', '>', content)

with open("module.dwarf","w") as f:
    f.write(content)
