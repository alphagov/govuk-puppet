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

def main():
    config = load_config()
    now = datetime.now()
    yesterday = now - timedelta(days=1)
    web_service_client = initiate_client(config["url"], config["username"], config["password"])
    results = request_event_data(web_service_client, yesterday, now)
    for item in results:
        print "[" + item.eventTime + "] Application: " + item.application + ", Action: " + item.action

if __name__ == '__main__':
    main()
