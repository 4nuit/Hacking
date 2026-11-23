for i in $(objdump -d *.o | grep "^ " | cut -f2); do echo -n '\x'$i; done; echo
