# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; only version 2 of the License is applicable.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

# This plugin is to monitor queue lengths in Redis. Based on redis_info.py by
# Garret Heaton <powdahound at gmail.com>, hence the GPL at the top.

import collectd
from contextlib import closing, contextmanager
import socket


# Host to connect to. Override in config by specifying 'Host'.
REDIS_HOST = 'localhost'

# Port to connect on. Override in config by specifying 'Port'.
REDIS_PORT = 6379

# Verbose logging on/off. Override in config by specifying 'Verbose'.
VERBOSE_LOGGING = False

# Queue names to monitor. Override in config by specifying 'Queues'.
QUEUE_NAMES = []


def fetch_queue_lengths(queue_names):
    """Connect to Redis server and request queue lengths.
    
    Return a dictionary from queue names to integers.
    
    """
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((REDIS_HOST, REDIS_PORT))
        log_verbose('Connected to Redis at %s:%s' % (REDIS_HOST, REDIS_PORT))
    except socket.error, e:
        collectd.error('redis_queues plugin: Error connecting to %s:%d - %r'
                       % (REDIS_HOST, REDIS_PORT, e))
        return None

    queue_lengths = {}

    with closing(s) as redis_socket:
        for queue_name in queue_names:
            log_verbose('Requesting length of queue %s' % queue_name)
            redis_socket.sendall('llen %s\r\n' % queue_name)
            with closing(redis_socket.makefile('r')) as response_file:
                response = response_file.readline()
            if response.startswith(':'):
                try:
                    queue_lengths[queue_name] = int(response[1:-1])
                except ValueError:
                    log_verbose('Invalid response: %r' % response)
            else:
                log_verbose('Invalid response: %r' % response)

    return queue_lengths


def configure_callback(conf):
    """Receive configuration block"""
    global REDIS_HOST, REDIS_PORT, VERBOSE_LOGGING, QUEUE_NAMES
    for node in conf.children:
        if node.key == 'Host':
            REDIS_HOST = node.values[0]
        elif node.key == 'Port':
            REDIS_PORT = int(node.values[0])
        elif node.key == 'Verbose':
            VERBOSE_LOGGING = bool(node.values[0])
        elif node.key == 'Queues':
            QUEUE_NAMES = list(node.values)
        else:
            collectd.warning('redis_queues plugin: Unknown config key: %s.'
                             % node.key)
    log_verbose('Configured with host=%s, port=%s' % (REDIS_HOST, REDIS_PORT))
    for queue in QUEUE_NAMES:
        log_verbose('Watching queue %s' % queue)
    if not QUEUE_NAMES:
        log_verbose('Not watching any queues')


def read_callback():
    log_verbose('Read callback called')
    queue_lengths = fetch_queue_lengths(QUEUE_NAMES)

    if queue_lengths is None:
        # An earlier error, reported to collectd by fetch_queue_lengths
        return

    for queue_name, queue_length in queue_lengths.items():
        log_verbose('Sending value: %s=%s' % (queue_name, queue_length))

        val = collectd.Values(plugin='redis_queues')
        val.type = 'gauge'
        val.type_instance = queue_name
        val.values = [queue_length]
        val.dispatch()


def log_verbose(msg):
    if not VERBOSE_LOGGING:
        return
    collectd.info('redis plugin [verbose]: %s' % msg)


# register callbacks
collectd.register_config(configure_callback)
collectd.register_read(read_callback)
