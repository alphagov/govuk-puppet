#
# Plugin to collectd statistics from RabbitMQ
#
import collectd
import subprocess
import re

VERBOSE_LOGGING = False

# Override in config by specifying 'RmqcBin'.
RABBITMQCTL_BIN = '/usr/sbin/rabbitmqctl'
NAME='RabbitMQ'

# Send log messages (via collectd) 
def logger(t, msg):
    if t == 'err':
        collectd.error('%s: %s' % (NAME, msg))
    if t == 'warn':
        collectd.warning('%s: %s' % (NAME, msg))
    elif t == 'verb' and VERBOSE_LOGGING == True:
        collectd.info('%s: %s' % (NAME, msg))

class RabbitMQ(object):

        def __init__(self):
                self.plugin_name = "rabbitmq"

        def send_values(self, queues):
                for queue in queues:
                        logger('verb', 'Dispatching %s : %i' % (queue['name'], queue['length']))
                        self.submit_single_stat('queue_length' , queue['name'],  int(queue['length']))

        def submit_single_stat(self, type, instance, value):
                v = collectd.Values()
                v.plugin = self.plugin_name
                v.plugin_instance = 'rabbitmq'
                v.type = type
                v.type_instance = instance
                v.values = [value, ]
                v.dispatch()

        def config(self, obj):
                print("config called for %s" % obj)

        # Obtain the interesting statistical info
        def get_rabbitmq_stats(self):
                stats = []
                # call rabbitmqctl
                try:
                        p = subprocess.Popen([RABBITMQCTL_BIN, '-q', 'list_queues', 'name', 'messages'], shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
                except:
                        logger('err', 'Failed to run %s' % RABBITMQCTL_BIN)
                        return None
                for line in p.stdout.readlines():
                        tokens = line.split()
                        if len(tokens)==2:
                                queue = {}
                                queue['name'] = tokens[0]
                                queue['length'] = int(tokens[1])
                                stats.append(queue)
                return stats

        def do_server_status(self):
                ctl_stats = self.get_rabbitmq_stats()
                self.send_values(ctl_stats)

rabbitmq = RabbitMQ()

if __name__=='__main__':
        print rabbitmq.get_ctl_stats()
else:
        collectd.register_read(rabbitmq.do_server_status)
        collectd.register_config(rabbitmq.config)

