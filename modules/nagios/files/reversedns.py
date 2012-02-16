#!/usr/bin/env python

import socket
import sys

# hacks to pickup correct graphs, due to local hosts and ganglia name mismatch
if sys.argv[1] in ['ip-10-54-182-112.eu-west-1.compute.internal', 'ip-10-236-86-54.eu-west-1.compute.internal', 'ip-10-250-157-37.eu-west-1.compute.internal', 'ip-10-53-54-49.eu-west-1.compute.internal']:
        print sys.argv[1]
        exit(0)
try:
        print socket.gethostbyaddr(sys.argv[1])[0]
except:
        print sys.argv[1]
