#!/usr/bin/env python

from suds import WebFault
from suds.client import Client
from datetime import datetime, timedelta
import logging
import yaml

logging.basicConfig(level=logging.INFO)
logging.getLogger('suds.client').setLevel(logging.WARN)

# - periodicity / state (how much have we got already)
# - add to cron
# - pass into syslog
# - what events are we picking up (have emailed ellen)
# - do proper exception handling of transport layer errors

LAST_RUN_FILE = 'last_run'

def load_config():
    """Function to load akamai web service configuration from a file
    """
    with open('akamai_logs.yaml') as f:
        return yaml.safe_load(f)["web_service"]

def initiate_client(url, username, password):
    """Setup suds SOAP client with HTTP basic authentication and the appropriate
    Akamai URL
    """
    client = Client(url, username=username, password=password)
    return client

def request_event_data(client, start, end):
    """ Get Akamai EdgeControl event alerts between given start date and end date
    TODO: introduce transport layer exception handling
    """
    response = client.service.getEdgeControlAlertsEvents(start, end)
    return response

def log_results(results):
    """ Write results out in a sensible way, at the moment just to STDOUT
    """
    for item in results:
        print "[" + item.eventTime + "] Application: " + item.application + ", Action: " + item.action


def write_last_run(event_time):
    """ Record the time when the script last succeeded in obtaining logs from Akamai
    to the last_run file.
    """
    nowdict = { "last_run" : event_time }
    with open (LAST_RUN_FILE, 'w') as f:
        f.write( yaml.dump( nowdict ) )

def get_interval():
    """ Using the last run file, and the current datestamp, work out the interval for this run of the
    script. If there is no last run file, then one will be created with the current datestamp, and no
    logs will be omitted (becasue the start and end date are the same).
    """
    now = datetime.now()
    try:
        with open (LAST_RUN_FILE, 'r') as f:
            last_run = yaml.safe_load(f)["last_run"]
    except IOError:
        last_run = now
    return last_run, now

def main():
    config = load_config()
    web_service_client = initiate_client(config["url"], config["username"], config["password"])

    start, end = get_interval()
    results = request_event_data(web_service_client, start, end)

    log_results(results)
    write_last_run(end)


if __name__ == '__main__':
    main()
