#!/usr/bin/python

import argparse
import sys
import urllib2

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
    parser = argparse.ArgumentParser(description='Check for Strict-Transport-Security header')
    parser.add_argument('--url', help='the URL to check', required=True)
    parser.add_argument('--maxage', help='optional expected max-age value', required=False, default=31536000)
    parser.add_argument('--username', help='optional username', required=False, default=False)
    parser.add_argument('--password', help='optional password', required=False, default=False)
    parser.add_argument('--realm', help='optional realm for basic auth', required=False, default="Enter the GOV.UK username/password (not your personal username/password)")
    args = parser.parse_args()

    url      = args.url
    expected = "max-age={0}".format(args.maxage)

    if args.username:
        if args.password:
            auth_handler = urllib2.HTTPBasicAuthHandler()
            auth_handler.add_password(realm=args.realm, uri=url, user=args.username, passwd=args.password)
            opener = urllib2.build_opener(auth_handler)
            urllib2.install_opener(opener)
        else:
            unknown("You have supplied a username, but not a password")

    response = urllib2.urlopen(url)
    sts_header = response.info().getheader('Strict-Transport-Security')

    if sts_header != expected:
        critical("Expected Strict-Transport-Security header on {0} to be {1} but found: {2}".format(url, expected, sts_header))
    else:
        ok("Expected Strict-Transport-Security header on {0} to be {1} and found: {2}".format(url, expected, sts_header))
except Exception, e:
    unknown("Unknown error: {0}".format(e))

