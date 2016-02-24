#!/usr/bin/env python
import json
import sys
from urllib2 import urlopen


def healthy_status():
    """
    Returns true if our cluster is green.
    Raises exception for HTTP errors.
    """
    response = urlopen('http://localhost:9200/_cluster/health')
    parsed = json.load(response)
    return parsed['status'] == 'green'


if __name__ == '__main__':
    if not healthy_status():
        sys.exit(1)
