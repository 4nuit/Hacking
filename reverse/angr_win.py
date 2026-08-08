#!/usr/bin/python3
import sys
import angr
import claripy

if (len(sys.argv) != 4):
    sys.exit("Usage ./angr_avoid_win.py <crackme> <len_flag> <addr_win>")

path_to_binary = argv[1]
p = angr.Project(path_to_binary)

flag = claripy.BVS("flag", 8*int(argv[2],0))
state = p.factory.full_init_state(args=[path_to_binary, flag])
sm = p.factory.simulation_manager(state)
sm.explore(find=int(argv[3],0))
s = sm.found[0]
sol = s.solver.eval(flag,cast_to=bytes)
print(sol)
