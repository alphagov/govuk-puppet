class govuk::node::s_logging inherits govuk::node::s_base {

# we want this to be a syslog server.
class { 'rsyslog::server': }

# we want all the other machines to be able to send syslog on 514/tcp to this machine
  @ufw::allow {
    'allow-syslog-from-backend':
      from => '10.3.0.0/16',
      port => 514;
    'allow-syslog-from-frontend':
      from => '10.2.0.0/16',
      port => 514;
    'allow-syslog-from-management':
      from => '10.0.0.0/16',
      port => 514;
  }
}
