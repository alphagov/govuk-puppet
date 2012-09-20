#!/usr/bin/env python

import socket
import sys

STATIC_MAPPING = {
    'ip-10-236-86-54.eu-west-1.compute.internal': 'frontend.production.alphagov.co.uk',
    'ip-10-250-157-37.eu-west-1.compute.internal': 'static.production.alphagov.co.uk',
    'ip-10-53-54-49.eu-west-1.compute.internal': 'frontend.cluster',
    'ip-10-54-182-112.eu-west-1.compute.internal': 'signonotron.production.alphagov.co.uk',
    'ip-10-32-31-104.eu-west-1.compute.internal': 'graylog.cluster',
    'ip-10-229-67-207.eu-west-1.compute.internal': 'whitehall.production.alphagov.co.uk',
    'ip-10-32-18-246.eu-west-1.compute.internal': 'puppet.cluster',
    'ip-10-237-35-45' : 'ip-10-237-35-45.eu-west-1.compute.internal',
    'ip-10-229-67-16' : 'ip-10-229-67-16.eu-west-1.compute.internal',
    'ip-10-239-11-229': 'ip-10-239-11-229.eu-west-1.compute.internal',
    'ip-10-32-34-170' : 'ip-10-32-34-170.eu-west-1.compute.internal',
    'ip-10-32-57-17'  : 'ip-10-32-57-17.eu-west-1.compute.internal'

}

def main():
    if len(sys.argv) != 2:
        print >>sys.stderr, 'Usage: python reversedns.py <name>'
        sys.exit(1)

    name = sys.argv[1]

    if name in STATIC_MAPPING:
        print STATIC_MAPPING[name]
        return

    try:
        print socket.gethostbyaddr(name)[0]
    except:
        print name


if __name__ == '__main__':
    main()
