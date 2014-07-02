# Name: rabbitmq-collectd-plugin - rabbitmq_info.py
# Author: https://github.com/phrawzty/rabbitmq-collectd-plugin/commits/master
# Description: This plugin uses Collectd's Python plugin to obtain RabbitMQ metrics.
#
# Copyright 2012 Daniel Maher
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import collectd
import subprocess
import re


NAME = 'rabbitmq_info'
# Override in config by specifying 'RmqcBin'.
RABBITMQCTL_BIN = '/usr/sbin/rabbitmqctl'
# Override in config by specifying 'PmapBin'
PMAP_BIN = '/usr/bin/pmap'
# Override in config by specifying 'PidofBin'.
PIDOF_BIN = '/bin/pidof'
# Override in config by specifying 'PidFile.
PID_FILE = "/var/run/rabbitmq/pid"
# Override in config by specifying 'Vhost'.
VHOST = "/"
# Override in config by specifying 'Verbose'.
VERBOSE_LOGGING = False


# Obtain the interesting statistical info
def get_stats():
    stats = {}
    stats['ctl_messages'] = 0
    stats['ctl_memory'] = 0
    stats['ctl_consumers'] = 0
    stats['pmap_mapped'] = 0
    stats['pmap_used'] = 0
    stats['pmap_shared'] = 0

    # call rabbitmqctl
    try:
        p = subprocess.Popen([RABBITMQCTL_BIN, '-q', '-p', VHOST,
            'list_queues', 'name', 'messages', 'memory', 'consumers'],
            shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    except:
        logger('err', 'Failed to run %s' % RABBITMQCTL_BIN)
        return None

    for line in p.stdout.readlines():
        ctl_stats = line.split()
        try:
            ctl_stats[1] = int(ctl_stats[1])
            ctl_stats[2] = int(ctl_stats[2])
            ctl_stats[3] = int(ctl_stats[3])
        except:
            continue
        queue_name = ctl_stats[0]
        stats['ctl_messages'] += ctl_stats[1]
        stats['ctl_memory'] += ctl_stats[2]
        stats['ctl_consumers'] += ctl_stats[3]
        stats['ctl_messages_%s' % queue_name] = ctl_stats[1]
        stats['ctl_memory_%s' % queue_name] = ctl_stats[2]
        stats['ctl_consumers_%s' % queue_name] = ctl_stats[3]

    if not stats['ctl_memory'] > 0:
        logger('warn', '%s reports 0 memory usage. This is probably incorrect.'
            % RABBITMQCTL_BIN)

    # get the pid of rabbitmq
    try:
        with open(PID_FILE, 'r') as f:
          pid = f.read().strip()
    except:
        logger('err', 'Unable to read %s' % PID_FILE)
        return None

    # use pmap to get proper memory stats
    try:
        p = subprocess.Popen([PMAP_BIN, '-d', pid], shell=False,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    except:
        logger('err', 'Failed to run %s' % PMAP_BIN)
        return None

    line = p.stdout.readlines()[-1].strip()
    if re.match('mapped', line):
        m = re.match(r"\D+(\d+)\D+(\d+)\D+(\d+)", line)
        stats['pmap_mapped'] = int(m.group(1))
        stats['pmap_used'] = int(m.group(2))
        stats['pmap_shared'] = int(m.group(3))
    else:
        logger('warn', '%s returned something strange.' % PMAP_BIN)
        return None

    # Verbose output
    logger('verb', '[rmqctl] Messages: %i, Memory: %i, Consumers: %i' %
        (stats['ctl_messages'], stats['ctl_memory'], stats['ctl_consumers']))
    logger('verb', '[pmap] Mapped: %i, Used: %i, Shared: %i' %
        (stats['pmap_mapped'], stats['pmap_used'], stats['pmap_shared']))

    return stats


# Config data from collectd
def configure_callback(conf):
    global RABBITMQCTL_BIN, PMAP_BIN, PID_FILE, VERBOSE_LOGGING, VHOST
    for node in conf.children:
        if node.key == 'RmqcBin':
            RABBITMQCTL_BIN = node.values[0]
        elif node.key == 'PmapBin':
            PMAP_BIN = node.values[0]
        elif node.key == 'PidFile':
            PID_FILE = node.values[0]
        elif node.key == 'Verbose':
            VERBOSE_LOGGING = bool(node.values[0])
        elif node.key == 'Vhost':
            VHOST = node.values[0]
        else:
            logger('warn', 'Unknown config key: %s' % node.key)


# Send info to collectd
def read_callback():
    logger('verb', 'read_callback')
    info = get_stats()

    if not info:
        logger('err', 'No information received - very bad.')
        return

    logger('verb', 'About to trigger the dispatch..')

    # send values
    for key in info:
        logger('verb', 'Dispatching %s : %i' % (key, info[key]))
        val = collectd.Values(plugin=NAME)
        val.type = 'gauge'
        val.type_instance = key
        val.values = [int(info[key])]
        val.dispatch()


# Send log messages (via collectd)
def logger(t, msg):
    if t == 'err':
        collectd.error('%s: %s' % (NAME, msg))
    if t == 'warn':
        collectd.warning('%s: %s' % (NAME, msg))
    elif t == 'verb' and VERBOSE_LOGGING == True:
        collectd.info('%s: %s' % (NAME, msg))


# Runtime
collectd.register_config(configure_callback)
collectd.warning('Initialising rabbitmq_info')
collectd.register_read(read_callback)
