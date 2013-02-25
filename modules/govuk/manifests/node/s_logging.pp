class govuk::node::s_logging inherits govuk::node::s_base {

# we want this to be a syslog server.
  class { 'rsyslog::server': }
# we also want it to send stuff to logstash
  class { 'rsyslog::logstash': }

# we want all the other machines to be able to send syslog on 514/tcp to this machine
  @ufw::allow {
    'allow-syslog-from-anywhere':
      from => '10.0.0.0/8',
      port => 514;
  }
}
