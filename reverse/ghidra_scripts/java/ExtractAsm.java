//@author 4nuit
//@category extract code from given function
//@runtime Java

import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.Instruction;

public class ExtractAsm extends GhidraScript {

    public void run() throws Exception {

        // Change this
        Function f = getFunction("FUN_1000000000");
        if (f == null) {
            println("Function not found");
            return;
        }

        Instruction ins = getInstructionAt(f.getEntryPoint());

        while (ins != null && f.getBody().contains(ins.getAddress())) {
            println(ins.toString());
            ins = ins.getNext();
        }
    }
}
