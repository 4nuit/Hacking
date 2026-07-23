#!/usr/bin/env python3
from scapy.all import *
from sys import argv

def fix_and_send(pkt, *, my_mac, out_mac, iface):
    q = pkt.copy()
    q[Ether].src, q[Ether].dst = my_mac, out_mac

    if IP in q:
        q[IP].len = None
        q[IP].chksum = None
    if TCP in q:
        q[TCP].chksum = None

    sendp(Ether(bytes(q)), iface=iface, verbose=False)

def main():
    if (len(argv) != 3):
        exit("Usage: ./sniff.py client_ip server_ip")
    client_ip, server_ip = argv[1], argv[2]

    iface = conf.iface
    my_mac = get_if_hwaddr(iface)
    a_mac = getmacbyip(client_ip)
    b_mac = getmacbyip(server_ip)

    next_hop = {
        (client_ip, server_ip): b_mac,
        (server_ip, client_ip): a_mac,
    }

    def fwd(p):
        if Ether not in p or IP not in p:
            return
        if p[Ether].dst != my_mac:
            return

        out_mac = next_hop.get((p[IP].src, p[IP].dst))
        if out_mac:
            fix_and_send(p, my_mac=my_mac, out_mac=out_mac, iface=iface)

    sniff(iface=iface, filter=f"ether dst {my_mac}", prn=fwd, store=0)

if __name__ == "__main__":
    main()
