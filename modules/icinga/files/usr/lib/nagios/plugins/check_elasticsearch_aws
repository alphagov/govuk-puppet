#!/usr/bin/env python2

from nagioscheck import NagiosCheck, UsageError
from nagioscheck import PerformanceMetric, Status
import urllib2

try:
    import json
except ImportError:
    import simplejson as json

HEALTH = {'red':    0,
          'yellow': 1,
          'green':  2}

HEALTH_MAP = {0: 'critical',
              1: 'warning',
              2: 'ok'}

class ElasticSearchCheck(NagiosCheck):
    def __init__(self):
        NagiosCheck.__init__(self)

        self.health = HEALTH['green']

        self.add_option('H', 'host', 'host', "Hostname or network "
                        "address to probe.  The ElasticSearch API "
                        "should be listening here.")

        self.add_option('p', 'port', 'port', "TCP port to probe.  "
                        "The ElasticSearch API should be listening "
                        "here.")

    def check(self, opts, args):
        if opts.host is None or opts.port is None:
          raise UsageError("Hostname and port must be specified")

        host = opts.host
        port = int(opts.port)

        es_cluster_health = get_json(r'http://%s:%d/_cluster/health' % (host, port))

        msg = "Monitoring cluster '%s'" % es_cluster_health['cluster_name']
        detail = []
        perfdata = []

        ## Cluster Health Status (green, yellow, red)
        cluster_status = HEALTH[es_cluster_health['status'].lower()]

        perfdata.append(PerformanceMetric(label='cluster_health',
                         value=es_cluster_health['status']))

        if cluster_status < self.health:
            raise Status('critical',
                         ("Elasticsearch cluster reports degraded health: '%s'" %
                          es_cluster_health['status'],),
                         perfdata)

        raise Status(HEALTH_MAP[self.health],
                     (msg, None, "%s\n\n%s" % (msg, "\n".join(detail))),
                     perfdata)

def get_json(uri):
    try:
        f = urllib2.urlopen(uri)
    except urllib2.HTTPError, e:
        raise Status('unknown', ("API failure: %s" % uri,
                                 None,
                                 "API failure:\n\n%s" % str(e)))
    except urllib2.URLError, e:
        # The server could be down; make this CRITICAL.
        raise Status('critical', (e.reason,))

    body = f.read()

    try:
        j = json.loads(body)
    except ValueError:
        raise Status('unknown', ("API returned nonsense",))

    return j

def main():
    ElasticSearchCheck().run()

if __name__ == '__main__':
    main()
