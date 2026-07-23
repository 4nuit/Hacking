# https://github.com/HackOvert/GhidraSnippets?tab=readme-ov-file#print-details-about-basic-blocks-in-a-select-function
import pyghidra

pyghidra.start()

from ghidra.program.model.block import BasicBlockModel
from ghidra.util.task import ConsoleTaskMonitor
from ghidra.program.flatapi import FlatProgramAPI


with pyghidra.open_program("binary") as flatapi:

    currentProgram = flatapi.getCurrentProgram()

    # replicate ghidra script environment helpers
    def getGlobalFunctions(name):
        funcs = currentProgram.getFunctionManager().getFunctions(True)
        return [f for f in funcs if f.getName() == name]

    def getFunctionAt(addr):
        return flatapi.getFunctionAt(addr)

    funcName = "main"
    blockModel = BasicBlockModel(currentProgram)
    monitor = ConsoleTaskMonitor()
    func = getGlobalFunctions(funcName)[0]

    print("Basic block details for function '{}':".format(funcName))
    blocks = blockModel.getCodeBlocksContaining(func.getBody(), monitor)

    # print first block
    print("\t[*] {} ".format(func.getEntryPoint()))

    # print any remaining blocks
    while(blocks.hasNext()):
        bb = blocks.next()
        dest = bb.getDestinations(monitor)
        while(dest.hasNext()):
            dbb = dest.next()
            # For some odd reason `getCodeBlocksContaining()` and `.next()`
            # return the root basic block after CALL instructions (x86). To filter
            # these out, we use `getFunctionAt()` which returns `None` if the address
            # is not the entry point of a function. See:
            # https://github.com/NationalSecurityAgency/ghidra/issues/855
            if not getFunctionAt(dbb.getDestinationAddress()):
                print("\t[*] {} ".format(dbb))
