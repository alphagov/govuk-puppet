#!/usr/bin/env python
# -*- coding: utf-8; -*-
#
# collectd implementation of:
# https://github.com/BrightcoveOS/Diamond/blob/master/src/collectors/tcp/tcp.py

import collectd
import os

class Tcp(object):

    PROC = ['/proc/net/netstat', '/proc/net/snmp']

    GAUGES = ['CurrEstab', 'MaxConn']


    def __init__(self):
        self.plugin_name = "tcp"
        self.allowed_metrics = []


    def config(self, obj):
        for node in obj.children:
            if node.key == 'Metrics':
                self.allowed_metrics = node.values


    def log(self, t, message):
        if t == 'err':
            collectd.error('%s: %s' %(self.plugin_name, message))
        elif t == 'warn':
            collectd.warning('%s: %s' %(self.plugin_name, message))
        elif t == 'verb':
            collectd.info('%s: %s' %(self.plugin_name, message))
        else:
            collectd.info('%s: %s' %(self.plugin_name, message))


    def submit(self, metric_name, value, type):
        v = collectd.Values()
        v.plugin = self.plugin_name
        v.type = type
        v.type_instance = metric_name
        v.values = [int(value)]
        v.dispatch()


    def collect(self):
        metrics = {}

        for filepath in self.PROC:
            if not os.access(filepath, os.R_OK):
                self.log('error', 'Permission to access %s denied' %filepath)
                continue

            header = ''
            data = ''

            # Seek the file for the lines that start with Tcp
            file = open(filepath)

            if not file:
                self.log('error', 'Failed to open %s' %filepath)
                continue

            while True:
                line = file.readline()

                # Reached EOF?
                if len(line) == 0:
                    break

                # Line has metrics?
                if line.startswith("Tcp"):
                    header = line
                    data = file.readline()
                    break
            file.close()

            # No data from the file?
            if header == '' or data == '':
                self.log('error', '%s has no lines with Tcp' %filepath)
                continue

            header = header.split()
            data = data.split()

            for i in xrange(1, len(header)):
                metrics[header[i]] = data[i]

            #Send TCP stats to collectd
            allowed_metrics = set(self.allowed_metrics).intersection(metrics.keys())
            for metric_name in metrics:
                if metric_name in allowed_metrics:
                    value = long(metrics[metric_name])
                    if metric_name in self.GAUGES:
                        self.submit(metric_name, value, 'gauge')
                    else:
                        self.submit(metric_name, value, 'counter')

tcp = Tcp()
collectd.register_read(tcp.collect)
collectd.register_config(tcp.config)
