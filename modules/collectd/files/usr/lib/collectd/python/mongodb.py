#
# Plugin to collectd statistics from MongoDB
#

import collectd
from pymongo import Connection


class MongoDB(object):

    def __init__(self):
        self.plugin_name = "mongo"
        self.mongo_host = "127.0.0.1"
        self.mongo_port = 27017
        self.mongo_db = ["admin", ]
        self.mongo_user = None
        self.mongo_password = None

        self.lockTotalTime = None
        self.lockTime = None
        self.accesses = None
        self.misses = None

    def submit(self, type, instance, value, db=None):
        if db:
            plugin_instance = '%s-%s' % (self.mongo_port, db)
        else:
            plugin_instance = str(self.mongo_port)
        v = collectd.Values()
        v.plugin = self.plugin_name
        v.plugin_instance = plugin_instance
        v.type = type
        v.type_instance = instance
        v.values = [value, ]
        v.dispatch()

    def do_server_status(self):
        con = Connection(host=self.mongo_host, port=self.mongo_port, slave_okay=True)
        db = con[self.mongo_db[0]]
        if self.mongo_user and self.mongo_password:
            db.authenticate(self.mongo_user, self.mongo_password)
        server_status = db.command('serverStatus')

        # operations
        for k, v in server_status['opcounters'].items():
            self.submit('total_operations', k, v)

        # memory
        for t in ['resident', 'virtual', 'mapped']:
            self.submit('memory', t, server_status['mem'][t])

        # connections
        self.submit('connections', 'connections', server_status['connections']['current'])

        # locks
        if self.lockTotalTime is not None and self.lockTime is not None:
            if self.lockTime == server_status['globalLock']['lockTime']:
                value = 0.0
            else:
                value = float(server_status['globalLock']['lockTime'] - self.lockTime) * 100.0 / float(server_status['globalLock']['totalTime'] - self.lockTotalTime)
            self.submit('percent', 'lock_ratio', value)

        self.lockTotalTime = server_status['globalLock']['totalTime']
        self.lockTime = server_status['globalLock']['lockTime']


        # indexes
        accesses = None
        misses = None
        if self.accesses is not None:
            accesses = server_status['indexCounters']['btree']['accesses'] - self.accesses
            if accesses < 0:
                accesses = None
        misses = (server_status['indexCounters']['btree']['misses'] or 0) - (self.misses or 0)
        if misses < 0:
            misses = None
        if accesses and misses is not None:
            self.submit('cache_ratio', 'cache_misses', int(misses * 100 / float(accesses)))
        else:
            self.submit('cache_ratio', 'cache_misses', 0)
        self.accesses = server_status['indexCounters']['btree']['accesses']
        self.misses = server_status['indexCounters']['btree']['misses']

        for mongo_db in self.mongo_db:
            db = con[mongo_db]
            if self.mongo_user and self.mongo_password:
                db.authenticate(self.mongo_user, self.mongo_password)
            db_stats = db.command('dbstats')

            # stats counts
            self.submit('counter', 'object_count', db_stats['objects'], mongo_db)
            self.submit('counter', 'collections', db_stats['collections'], mongo_db)
            self.submit('counter', 'num_extents', db_stats['numExtents'], mongo_db)
            self.submit('counter', 'indexes', db_stats['indexes'], mongo_db)

            # stats sizes
            self.submit('file_size', 'storage', db_stats['storageSize'], mongo_db)
            self.submit('file_size', 'index', db_stats['indexSize'], mongo_db)
            self.submit('file_size', 'data', db_stats['dataSize'], mongo_db)

        con.disconnect()

    def config(self, obj):
        for node in obj.children:
            if node.key == 'Port':
                self.mongo_port = int(node.values[0])
            elif node.key == 'Host':
                self.mongo_host = node.values[0]
            elif node.key == 'User':
                self.mongo_user = node.values[0]
            elif node.key == 'Password':
                self.mongo_password = node.values[0]
            elif node.key == 'Database':
                self.mongo_db = node.values
            else:
                collectd.warning("mongodb plugin: Unkown configuration key %s" % node.key)

mongodb = MongoDB()
collectd.register_read(mongodb.do_server_status)
collectd.register_config(mongodb.config)
