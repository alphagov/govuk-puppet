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
    source      => "https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar",
    destination => "/var/tmp/logstash-1.1.9-monolithic.jar",
    require     => Class['java::oracle7::jre'],
  }
  class { 'logstash':
    provider    => 'custom',
    jarfile     => 'file:///var/tmp/logstash-1.1.9-monolithic.jar',
    installpath => '/srv/logstash',
    require     => Wget::Fetch['logstash-monolithic'],
  }

#configure logstash inputs
  logstash::input::tcp {'syslog':
    type => 'syslog',
    port => '5544',
  }
  logstash::input::udp {'syslog':
    type => 'syslog',
    port => '5544',
  }

#configure logstash filters
  logstash::filter::grok {'syslog':
    type      => 'syslog',
    pattern   => [ "<%{POSINT:syslog_pri}>%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{PROG:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" ],
    add_field => {
      "received_at"   => "%{@timestamp}",
      "received_from" => "%{@source_host}"
      },
    order     => '11',
  }
  logstash::filter::syslog_pri {'syslog':
    type  => 'syslog',
    order => '12',
  }
  logstash::filter::date {'syslog':
    type  => 'syslog',
    match => [ "syslog_timestamp", "MMM dd HH:mm:ss",
          "MMM  d HH:mm:ss" ],
    order => '13',
  }
  logstash::filter::mutate {'syslog-1':
    type         => 'syslog',
    order        => '14',
    exclude_tags => [ "_grokparsefailure" ],
    replace      => {
      "@source_host" => "%{syslog_hostname}",
      "@message"     => "%{syslog_message}"
      },
  }
  logstash::filter::mutate {'syslog-2':
    type   => 'syslog',
    order  => '15',
    remove => [ "syslog_hostname", "syslog_message", "syslog_timestamp" ],
  }

#configure logstash outputs

  logstash::output::elasticsearch_http {'syslog':
    host  => "elasticsearch-1.management",
    index => "logs-current",
  }

}
