#!/usr/bin/env python
"""
Read plugin for Fastly CDN stats.

TODO:
    - Authenticate with user/pass instead of global API key.
    - Track last query date so that we can fill in blanks?
"""

import collectd
import json
import httplib
import urllib
import datetime
import calendar

# Must be rounded to 1min because that's the highest resolution that Fastly
# provide data for. collectd will only call the plugin this often.
# Ref: http://docs.fastly.com/api/stats#Range
INTERVAL = 60

class CdnFastly(object):
    def __init__(self):
        self.API_HOST = "api.fastly.com"
        self.API_URL = "/stats/service/%(service_id)s?%(params)s"
        self.PLUGIN_NAME = "cdn_fastly"

        self.delay_mins = 10
        self.api_timeout = 5
        self.api_key = None
        self.services = {}

    def _warn(self, message):
        collectd.warning("cdn_fastly plugin: %s" % message)

    def _raise(self, message):
        raise Exception("cdn_fastly plugin: %s" % message)

    def config(self, conf):
        """
        Configure the plugin.
        """
        for node in conf.children:
            if node.key == 'ApiKey':
                self.api_key = node.values[0]
            elif node.key == 'ApiTimeout':
                self.api_timeout = node.values[0]
            elif node.key == 'DelayMins':
                self.delay_mins = int(node.values[0])
            elif node.key == 'Service':
                if node.children[0].key == 'Id':
                    self.services[node.values[0]] = node.children[0].values[0]
                else:
                    self._warn("Unknown config key: %s" % node.children[0].key)
            else:
                self._warn("Unknown config key: %s" % node.key)

        if not self.api_key:
            self._raise("No ApiKey configured")

        if self.services < 0:
            self._raise("No Service blocks configured")

    def read(self):
        """
        Fetch and submit data. Called once per INTERVAL.
        """
        time_from, time_to = self.get_time_range()

        for service_name, service_id in self.services.items():
            try:
                service_data = self.request(service_id, time_from, time_to)
            except:
                self._warn("Failed to query service: %s" % service_name)
                continue

            for service_period in service_data:
                vtime = service_period.pop('start_time')
                del service_period['service_id']

                for key, val in service_period.items():
                    val, vtype = self.scale_and_type(key, val)
                    self.submit(service_name, key, vtype, val, vtime)

    def scale_and_type(self, key, val):
        """
        Find the appropriate data type and scale the value by INTERVAL
        where required.

        Ref: http://collectd.org/documentation/manpages/types.db.5.shtml
        """
        if key.endswith('_time'):
            vtype = 'response_time'
        elif key.endswith('_ratio'):
            vtype = 'cache_ratio'
            val = float(val)
        elif key.endswith('_size') or key == 'bandwidth':
            vtype = 'bytes'
            val = val / INTERVAL
        else:
            vtype = 'requests'
            val = val / INTERVAL

        return val, vtype

    def get_time_range(self):
        """
        Construct a time range for which to query stats for.

        This is called once per `self.read()` so that we query the same time
        period for all services consistently no matter how long the request
        takes.

        A delay of `self.delay_mins` is applied because Fastly's data from
        edge is 10~15 mins behind the present time.

        Ref: http://docs.fastly.com/api/stats#Availability
        """
        # Timestamp rounded down to the minute.
        now = calendar.timegm(
            datetime.datetime.now().replace(
                second=0, microsecond=0
            ).utctimetuple()
        )

        time_to = now - (self.delay_mins * 60)
        time_from = time_to - INTERVAL

        return time_from, time_to

    def submit(self, service_name, metric_name, metric_type, value, time):
        """
        Submit a single metric with the appropriate properties.
        """
        v = collectd.Values()
        v.plugin = self.PLUGIN_NAME
        v.plugin_instance = service_name

        v.type = metric_type
        v.type_instance = metric_name

        v.time = time
        v.values = [value, ]
        v.interval = INTERVAL

        v.dispatch()

    def request(self, service_id, time_from, time_to):
        """
        Requests stats from Fastly's API and return a dict of data. May
        contain multiple time periods.
        """
        params = urllib.urlencode({
            'from': time_from,
            'to': time_to,
            'by': "minute",
        })
        url = self.API_URL % {
            'service_id': service_id,
            'params': params,
        }
        headers = {
            'Fastly-Key': self.api_key,
        }

        conn = httplib.HTTPSConnection(self.API_HOST, timeout=self.api_timeout)
        conn.request("GET", url, headers=headers)

        resp = conn.getresponse().read()
        data = json.loads(resp)['data']

        return data

cdn_fastly = CdnFastly()
collectd.register_config(cdn_fastly.config)
collectd.register_read(cdn_fastly.read, INTERVAL)
