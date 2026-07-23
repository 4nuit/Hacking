# https://github.com/HackOvert/GhidraSnippets?tab=readme-ov-file#enumerate-all-functions-printing-their-name-and-address
import pyghidra

with pyghidra.open_program("binary") as api:
    fm = api.getCurrentProgram().getFunctionManager()
    for func in fm.getFunctions(True):
        print("Function: {} @ 0x{}".format(func.getName(), func.getEntryPoint()))
