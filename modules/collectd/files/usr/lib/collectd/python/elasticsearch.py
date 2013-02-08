#! /usr/bin/python

import collectd
import json
import urllib2
import socket

global URL, STAT, PREFIX, ES_HOST, ES_PORT, ES_CLUSTER

PREFIX = "elasticsearch"
ES_CLUSTER = "elasticsearch"
ES_HOST = "localhost"
ES_PORT = 9200
VERBOSE_LOGGING = False
STAT=dict()

# INDICES METRICS #
## CACHE
STAT['indices.cache.field.eviction'] = { "type": "counter", "path": "nodes.%s.indices.cache.field_evictions" }
STAT['indices.cache.field.size'] = { "type": "bytes", "path": "nodes.%s.indices.cache.field_size_in_bytes" }
STAT['indices.cache.filter.count'] = { "type": "counter", "path": "nodes.%s.indices.cache.filter_count" }
STAT['indices.cache.filter.evictions'] = { "type": "counter", "path": "nodes.%s.indices.cache.filter_evictions" }
STAT['indices.cache.filter.size'] = { "type": "bytes", "path": "nodes.%s.indices.cache.filter_size_in_bytes" }

## DOCS
STAT['indices.docs.count'] = { "type": "gauge", "path": "nodes.%s.indices.docs.count" }
STAT['indices.docs.deleted'] = { "type": "counter", "path": "nodes.%s.indices.docs.deleted" }

## FLUSH
STAT['indices.flush.total'] = { "type": "counter", "path": "nodes.%s.indices.flush.total" }
STAT['indices.flush.time'] = { "type": "counter", "path": "nodes.%s.indices.flush.total_time_in_millis" }

## GET
STAT['indices.get.exists-time'] = { "type": "counter", "path": "nodes.%s.indices.get.exists_time_in_millis" }
STAT['indices.get.exists-total'] = { "type": "counter", "path": "nodes.%s.indices.get.exists_total" }
STAT['indices.get.time'] = { "type": "counter", "path": "nodes.%s.indices.get.time_in_millis" }
STAT['indices.get.total'] = { "type": "counter", "path": "nodes.%s.indices.get.total" }
STAT['indices.get.missing-time'] = { "type": "counter", "path": "nodes.%s.indices.get.missing_time_in_millis" }
STAT['indices.get.missing-total'] = { "type": "counter", "path": "nodes.%s.indices.get.missing_total" }

## INDEXING
STAT['indices.indexing.delete-time'] = { "type": "counter", "path": "nodes.%s.indices.indexing.delete_time_in_millis" }
STAT['indices.indexing.delete-total'] = { "type": "counter", "path": "nodes.%s.indices.indexing.delete_total" }
STAT['indices.indexing.index-time'] = { "type": "counter", "path": "nodes.%s.indices.indexing.index_time_in_millis" }
STAT['indices.indexing.index-total'] = { "type": "counter", "path": "nodes.%s.indices.indexing.index_total" }

## MERGES
STAT['indices.merges.current'] = { "type": "gauge", "path": "nodes.%s.indices.merges.current" }
STAT['indices.merges.current-docs'] = { "type": "gauge", "path": "nodes.%s.indices.merges.current_docs" }
STAT['indices.merges.current-size'] = { "type": "bytes", "path": "nodes.%s.indices.merges.current_size_in_bytes" }
STAT['indices.merges.total'] = { "type": "counter", "path": "nodes.%s.indices.merges.total" }
STAT['indices.merges.total-docs'] = { "type": "gauge", "path": "nodes.%s.indices.merges.total_docs" }
STAT['indices.merges.total-size'] = { "type": "bytes", "path": "nodes.%s.indices.merges.total_size_in_bytes" }
STAT['indices.merges.time'] = { "type": "counter", "path": "nodes.%s.indices.merges.total_time_in_millis" }

## REFRESH
STAT['indices.refresh.total'] = { "type": "counter", "path": "nodes.%s.indices.refresh.total" }
STAT['indices.refresh.time'] = { "type": "counter", "path": "nodes.%s.indices.refresh.total_time_in_millis" }

## SEARCH
STAT['indices.search.query-current'] = { "type": "gauge", "path": "nodes.%s.indices.search.query_current" }
STAT['indices.search.query-total'] = { "type": "counter", "path": "nodes.%s.indices.search.query_total" }
STAT['indices.search.query-time'] = { "type": "counter", "path": "nodes.%s.indices.search.query_time_in_millis" }
STAT['indices.search.fetch-current'] = { "type": "counter", "path": "nodes.%s.indices.search.fetch_current" }
STAT['indices.search.fetch-total'] = { "type": "counter", "path": "nodes.%s.indices.search.fetch_total" }
STAT['indices.search.fetch-time'] = { "type": "counter", "path": "nodes.%s.indices.search.fetch_time_in_millis" }

## STORE
STAT['indices.store.size'] = { "type": "bytes", "path": "nodes.%s.indices.store.size_in_bytes" }

# JVM METRICS #
## MEM
STAT['jvm.mem.heap-committed'] = { "type": "bytes", "path": "nodes.%s.jvm.mem.heap_committed_in_bytes" }
STAT['jvm.mem.heap-used'] = { "type": "bytes", "path": "nodes.%s.jvm.mem.heap_used_in_bytes" }
STAT['jvm.mem.non-heap-committed'] = { "type": "bytes", "path": "nodes.%s.jvm.mem.non_heap_committed_in_bytes" }
STAT['jvm.mem.non-heap-used'] = { "type": "bytes", "path": "nodes.%s.jvm.mem.non_heap_used_in_bytes" }

## THREADS
STAT['jvm.threads.count'] = { "type": "gauge", "path": "nodes.%s.jvm.threads.count" }
STAT['jvm.threads.peak'] = { "type": "gauge", "path": "nodes.%s.jvm.threads.peak_count" }

## GC
STAT['jvm.gc.time'] = { "type": "counter", "path": "nodes.%s.jvm.gc.collection_time_in_millis" }
STAT['jvm.gc.count'] = { "type": "counter", "path": "nodes.%s.jvm.gc.collection_count" }

# TRANSPORT METRICS #
STAT['transport.server_open'] = { "type": "gauge", "path": "nodes.%s.transport.server_open" }
STAT['transport.rx.count'] = { "type": "counter", "path": "nodes.%s.transport.rx_count" }
STAT['transport.rx.size'] = { "type": "bytes", "path": "nodes.%s.transport.rx_size_in_bytes" }
STAT['transport.tx.count'] = { "type": "counter", "path": "nodes.%s.transport.tx_count" }
STAT['transport.tx.size'] = { "type": "bytes", "path": "nodes.%s.transport.tx_size_in_bytes" }

# HTTP METRICS #
STAT['http.current_open'] = { "type": "gauge", "path": "nodes.%s.http.current_open" }
STAT['http.total_open'] = { "type": "gauge", "path": "nodes.%s.http.total_opened" }

# PROCESS METRICS #
STAT['process.open_file_descriptors'] = { "type": "gauge", "path": "nodes.%s.process.open_file_descriptors" }

# FUNCTION: Collect stats from JSON result
def lookup_stat(stat, json):

    node = json['nodes'].keys()[0]
    val = dig_it_up(json, STAT[stat]["path"] % node )

    # Check to make sure we have a valid result
    # dig_it_up returns False if no match found
    if not isinstance(val,bool):
        return int(val)
    else:
        return None

def configure_callback(conf):
    """Received configuration information"""
    global ES_HOST, ES_PORT, ES_URL, VERBOSE_LOGGING
    for node in conf.children:
        if node.key == 'Host':
            ES_HOST = node.values[0]
        elif node.key == 'Port':
            ES_PORT = int(node.values[0])
        elif node.key == 'Verbose':
            VERBOSE_LOGGING = bool(node.values[0])
        elif node.key == 'Cluster':
            ES_CLUSTER = node.values[0]
        else:
            collectd.warning('elasticsearch plugin: Unknown config key: %s.'
                             % node.key)
    ES_URL = "http://" + ES_HOST + ":" + str(ES_PORT) + "/_cluster/nodes/_local/stats?http=true&process=true&jvm=true&transport=true"

    log_verbose('Configured with host=%s, port=%s, url=%s' % (ES_HOST, ES_PORT, ES_URL))

def fetch_stats(): 
    global ES_URL, ES_CLUSTER

    try:
        result = json.load(urllib2.urlopen(ES_URL, timeout = 10))
    except urllib2.URLError, e:
        collectd.error('elasticsearch plugin: Error connecting to %s - %r' % (ES_URL, e))
        return None
    print result['cluster_name']
  
    ES_CLUSTER = result['cluster_name']
    return parse_stats(result)

def parse_stats(json):
    """Parse stats response from ElasticSearch"""
    for name,key in STAT.iteritems():
        result = lookup_stat(name, json)
        dispatch_stat(result, name, key)

def dispatch_stat(result, name, key):
    """Read a key from info response data and dispatch a value"""
    if not key.has_key("path"):
        collectd.warning('elasticsearch plugin: Stat not found: %s' % key)
        return
    type = key["type"]
    value = int(result)
    log_verbose('Sending value[%s]: %s=%s' % (type, name, value))

    val = collectd.Values(plugin='elasticsearch')
    val.plugin_instance = ES_CLUSTER
    val.type = type
    val.type_instance = name
    val.values = [value]
    val.dispatch()

def read_callback():
    log_verbose('Read callback called')
    stats = fetch_stats()

def dig_it_up(obj,path):
    try:
        if type(path) in (str,unicode):
            path = path.split('.')
        return reduce(lambda x,y:x[y],path,obj)
    except:
        return False

def log_verbose(msg):
    if not VERBOSE_LOGGING:
        return
    collectd.info('elasticsearch plugin [verbose]: %s' % msg)

collectd.register_config(configure_callback)
collectd.register_read(read_callback)

