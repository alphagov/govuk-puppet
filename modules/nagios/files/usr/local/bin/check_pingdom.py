#!/usr/bin/env python
import sys
import ConfigParser
import json
from urllib2 import *

# other config
pingdom_user     = ""
pingdom_pass     = ""
pingdom_key      = ""
pingdom_api_host = "api.pingdom.com"
config_file      = "/etc/pingdom.ini"
check_id = 0

def unknown(message):
    print "UNKNOWN: %s" % message
    sys.exit(3)

def critical(message):
    print "CRITICAL: %s" % message
    sys.exit(2)

def warning(message):
    print "WARNING: %s" % message
    sys.exit(1)

def ok(message):
    print "OK: %s" % message
    sys.exit(0)

def read_config():
    try:
        config = ConfigParser.ConfigParser()
        config.read(config_file)
        global pingdom_pass
        global pingdom_key
        global pingdom_user
        pingdom_pass = config.get('DEFAULT','pingdom_pass')
        pingdom_key  = config.get('DEFAULT','pingdom_key')
        pingdom_user = config.get('DEFAULT','pingdom_user')
    except:
        unknown("Could not read config file " % config_file)

def check_arguments():
    if len(sys.argv) != 2:
        unknown("No check ID passed as a parameter")
    else:
        global check_id
        check_id = sys.argv[1]

def check_pingdom_up():
    try:
        urlopen("https://%s/" % pingdom_api_host, None, 5)
    except HTTPError:
        pass
    except:
        unknown("Pingdom API Down")

def get_pingdom_result():
    try:
        basic_auth_token = "Basic " + (pingdom_user + ":" + pingdom_pass).encode("base64").rstrip()
        pingdom_url = "https://%s/api/2.0/checks/%s" % (pingdom_api_host, check_id)
        req = Request(pingdom_url)
        req.add_header("App-Key", pingdom_key)
        req.add_header("Authorization", basic_auth_token)
        try:
            result = urlopen(req)
        except HTTPError:
            unknown("Could not retrieve check result")
        pingdom_check = json.loads(result.read())
        try:
            status = pingdom_check['check']['status']
            if status == 'up':
                ok("Pingdom reports this URL is UP")
            elif status in ['unknown']:
                unknown("Pingdom check in unknown state")
            elif status in ['unconfirmed_down','paused']:
                warning("Pingdom check in %s state" % status)
            else:
                critical("Pingdom reports this URL is not UP")
        except Exception, e:
            unknown("Could not parse Pingdom output")
    except Exception, e:
        unknown("Unknown %s retrieving check status" % e)

check_arguments()
read_config()
check_pingdom_up()
get_pingdom_result()
