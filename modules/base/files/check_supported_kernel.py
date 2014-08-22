#!/usr/bin/python

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
    version = os.uname()[2].split('.')
    major_version = int(version[0])
    minor_version = int(version[1])
    if major_version == 3:
        if minor_version == 13 :
            ok("Running the recommended kernel version")
        elif minor_version in [ 11, 8, 5 ]:
            critical("Not running a supported kernel version, see https://wiki.ubuntu.com/1204_HWE_EOL - may just need to reboot")
        elif minor_version == 2:
            warning("Not running a recommended kernel version, upgrade to linux-generic-lts-trusty series, see https://wiki.ubuntu.com/1204_HWE_EOL - may just need to reboot")
        else:
            critical("Unknown kernel - not expecting Ubuntu machines to run a 3.{0} kernel".format(minor_version))
    else:
        unknown("Not expecting a kernel major version of {0} - see https://wiki.ubuntu.com/1204_HWE_EOL".format(major_version))
except Exception, e:
    unknown("Unknown error: {0}".format(e))
