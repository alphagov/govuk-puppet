#!/usr/bin/env python
# -*- coding: utf-8; -*-
"""
Copyright (C) 2013 - Kaan Özdinçer <kaanozdincer@gmail.com>

This file is part of rabbitmq-collect-plugin.

rabbitmq-collectd-plugin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

rabbitmq-collectd-plugin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>

"""
import collectd
import urllib2
import json

NAME = 'rabbitmq'
HOST = 'localhost'
PORT = '15672'
USER = 'guest'
PASS = 'guest'
VERBOSE = False

# Get all statistics with rabbitmqctl
def get_rabbitmqctl_status():
    stats = {}

    url_overview = 'http://%s:%s/api/overview' %(HOST, PORT)
    passman = urllib2.HTTPPasswordMgrWithDefaultRealm()
    passman.add_password(None, url_overview, USER, PASS)
    authhandler = urllib2.HTTPBasicAuthHandler(passman)
    opener = urllib2.build_opener(authhandler)
    urllib2.install_opener(opener)
    overview = json.load(urllib2.urlopen(url_overview))

    url_nodes = 'http://%s:%s/api/nodes' %(HOST, PORT)
    passman = urllib2.HTTPPasswordMgrWithDefaultRealm()
    passman.add_password(None, url_nodes, USER, PASS)
    authhandler = urllib2.HTTPBasicAuthHandler(passman)
    opener = urllib2.build_opener(authhandler)
    urllib2.install_opener(opener)
    nodes = json.load(urllib2.urlopen(url_nodes))

    # Message Stats
    try:
        stats['ack_rate'] = int(overview['message_stats']['ack_details']['rate'])
        stats['deliver_rate'] = int(overview['message_stats']['deliver_details']['rate'])
        stats['publish_rate'] = int(overview['message_stats']['publish_details']['rate'])
    except KeyError:
        log("warn", "no message stats available")

    # Queue Totals
    stats['messages_total'] = int(overview['queue_totals']['messages'])
    stats['messages_ready'] = int(overview['queue_totals']['messages_ready'])
    stats['messages_unack'] = int(overview['queue_totals']['messages_unacknowledged'])

    # Object Totals
    stats['channels'] = int(overview['object_totals']['channels'])
    stats['connections'] = int(overview['object_totals']['connections'])
    stats['consumers'] = int(overview['object_totals']['consumers'])
    stats['exchanges'] = int(overview['object_totals']['exchanges'])
    stats['queues'] = int(overview['object_totals']['queues'])

    # Node Stats
    stats['fd_total'] = int(nodes[0]['fd_total'])
    stats['fd_used'] = int(nodes[0]['fd_used'])
    stats['mem_limit'] = int(nodes[0]['mem_limit'])
    stats['mem_used'] = int(nodes[0]['mem_used'])
    stats['sockets_total'] = int(nodes[0]['sockets_total'])
    stats['sockets_used'] = int(nodes[0]['sockets_used'])
    stats['proc_total'] = int(nodes[0]['proc_total'])
    stats['proc_used'] = int(nodes[0]['proc_used'])

    return stats

# Config data from collectd
def configure_callback(conf):
    log('verb', 'configure_callback Running')
    global NAME, HOST, PORT, USER, PASS, VERBOSE
    for node in conf.children:
        if node.key == 'Name':
            NAME = node.values[0]
        elif node.key == 'Host':
            HOST = node.values[0]
        elif node.key == 'Port':
            PORT = node.values[0]
        elif node.key == 'User':
            USER = node.values[0]
        elif node.key == 'Pass':
            PASS = node.values[0]
        elif node.key == 'Verbose':
            VERBOSE = node.values[0]
        else:
            log('warn', 'Unknown config key: %s' %node.key)

# Send rabbitmq stats to collectd
def read_callback():
    log('verb', 'read_callback Running')
    info = get_rabbitmqctl_status()

    # Send keys to collectd
    for key in info:
        log('verb', 'Sent value: %s %i' %(key, info[key]))
        value = collectd.Values(plugin=NAME)
        value.type = 'gauge'
        value.type_instance = key
        value.values = [int(info[key])]
        value.dispatch()

# Log messages to collect logger
def log(t, message):
    if t == 'err':
        collectd.error('%s: %s' %(NAME, message))
    elif t == 'warn':
        collectd.warning('%s: %s' %(NAME, message))
    elif t == 'verb' and VERBOSE == True:
        collectd.info('%s: %s' %(NAME, message))
    else:
        collectd.info('%s: %s' %(NAME, message))

# Register to collectd
collectd.register_config(configure_callback)
collectd.warning('Initialising %s' %NAME)
collectd.register_read(read_callback)
