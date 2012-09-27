#!/usr/bin/python
#
#
#  notes:
# haporxy socket should be r/w by ganglia user
# stats socket /var/run/haproxy.sock group ganglia mode 775 level operator

import os
import sys
import re
import socket

from optparse import OptionParser
from cStringIO import StringIO
from time import time


def parse_stats(name):
    pxname, svname, stat = name.split("_", 2)
    
    raw_stats = get_stats(params2)
    raw_stats.seek(0)
    #print raw_stats
    expr = re.compile(",".join([pxname, svname]))
    raw_stats.seek(0)
    filtered_stats = filter(expr.search,raw_stats) #should only yield one line!
    
    stats_values = filtered_stats[0].split(",")
    
    stats = dict(zip(stats_keys, stats_values))
    #print stats
    #return stats 
    return int(stats[stat] or 0)

def get_stats(params):    
    buff = StringIO()
    end = time() + float(params['socket_timeout'])
    
    client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    
    try:
        client.connect(params['stats_socket'])
        client.send('show stat' + '\n')
    
        while time() <=  end:
            data = client.recv(4096)
            if data:
                buff.write(data)
            else:
                return buff
    except Exception, e:
        raise
    finally:
        client.close()

def metric_init(params):
    global services, descriptors, stats_keys
    global params2
    
    params2 = params
    services = params2['services'].split(",")
    descriptors = []
    
    stats_keys = ['pxname','svname','qcur','qmax','scur','smax','slim',
              'stot','bin','bout','dreq','dresp','ereq','econ','eresp',
              'wretr','wredis','status','weight','act','bck','chkfail',
              'chkdown','lastchg','downtime','qlimit','pid','iid','sid',
              'throttle','lbtot','tracked','type','rate','rate_lim',
              'rate_max','check_status','check_code','check_duration',
              'hrsp_1xx','hrsp_2xx','hrsp_3xx','hrsp_4xx','hrsp_5xx',
              'hrsp_other','hanafail','req_rate','req_rate_max',
              'req_tot','cli_abrt','srv_abrt']
    stats_descriptions = ['pxname','Service Name','Queue Current','Queue Max',
                          'Session Current','Session Max','Session Limit',
                          'Session Total','Bytes In','Bytes Out','dreq','dresp','ereq','econ','eresp',
                          'wretr','wredis','Status','Weight','Is Active','Is Backup','Failed Health Checks',
                          'chkdown','lastchg','Down Time','Queue Limit','pid','iid','sid',
                          'throttle','lbtot','tracked','type','Session Rate','Session Rate Limit',
                          'Session Rate Max','check_status','check_code','check_duration',
                          'hrsp_1xx','hrsp_2xx','hrsp_3xx','hrsp_4xx','hrsp_5xx',
                          'hrsp_other','hanafail','req_rate','req_rate_max',
                          'req_tot','Client Aborts','Server Aborts']
    stats_info = dict(zip(stats_keys, stats_descriptions))
    
    for srv_end in services:
        srv, end = srv_end.split("_")
        dees = []
        for px in ['qcur','scur','smax','stot','rate','rate_max']:
            d = {'name': '%s_%s_%s' % (srv, end, px),
                'call_back': parse_stats,
                'time_max': 90,
                'value_type': 'uint',
                'units': 'requests',
                'slope': 'both',
                'format': '%d',
                'description': stats_info[px],
                'groups': 'haproxy'}
            dees.append(d)
        descriptors.extend(dees)  
    
    #descriptors = [d1, d2, d3, d4, d5, d6]

    return descriptors

def metric_cleanup():
    '''Clean up the metric module.'''
    pass

#This code is for debugging and unit testing
if __name__ == '__main__':
    params = { 'stats_socket' : '/var/run/haproxy.sock',
               'socket_timeout': 15,
               'services' : 'http_FRONTEND,https_FRONTEND,apache80_BACKEND,apache443_BACKEND',
               'groups' : 'haproxy',
               }
    
    metric_init(params)
    for d in descriptors:
        v = d['call_back'](d['name'])
        print '%s,%u  (%s)' % (d['name'],  v, d['description'])
