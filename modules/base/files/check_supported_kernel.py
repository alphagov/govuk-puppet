#!/usr/bin/python

from decimal import Decimal
import math
import os
import sys

def nagios_exit(message, code):
    print message
    sys.exit(code)

def ok(message):
    nagios_exit("OK: " + message, 0)

def warning(message):
    nagios_exit("WARNING: " + message, 1)

def critical(message):
    nagios_exit("CRITICAL: " + message, 2)

def unknown(message):
    nagios_exit("UNKNOWN: " + message, 3)

try:
    version = Decimal("{0}.{1}".format(*os.uname()[2].split('.')))
    if version < Decimal('4.4'):
        critical("Not running a supported kernel version, see https://wiki.ubuntu.com/1404_HWE_EOL - may just need to reboot")
    elif version >= 5:
        unknown("Not expecting a kernel major version of {0} - see https://wiki.ubuntu.com/1404_HWE_EOL".format(math.floor(version)))
    else:
        ok("Running the recommended kernel version")
except Exception, e:
    unknown("Unknown error: {0}".format(e))
