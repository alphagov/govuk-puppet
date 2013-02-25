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

include java::oracle7::jre
# TODO: this should really be done with a package. 

  wget::fetch { 'logstash-monolithic':
    source => "https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar",
    destination => "/var/tmp/logstash-1.1.9-monolithic.jar",
    require            => Class['java::oracle7::jre'],
  }
  class { 'logstash':
    provider => 'custom',
    jarfile  => 'file:///var/tmp/logstash-1.1.9-monolithic.jar',
    installpath => '/srv/logstash',
    require => Wget::Fetch['logstash-monolithic'],
  }

}
