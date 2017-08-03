# == Class: govuk::node::s_logging
#
# Node class for logging centralisation and parsing machine.
#
class govuk::node::s_logging (
  $compress_srv_logs_hour = '1',
) inherits govuk::node::s_base {

  # we want this to be a syslog server which also forwards to logstash
  class { 'rsyslog::server':
    custom_config => 'govuk/etc/rsyslog.d/server-logstash.conf.erb',
  }

  # we want all the other machines to be able to send syslog on 514/tcp to this machine
  @ufw::allow {
    'allow-syslog-from-anywhere':
      from => 'any',
      port => 514;
  }

  include govuk_java::oracle7::jre
  # TODO: this should really be done with a package.

  if $::aws_migration {
    $logstash_jar_url = 'https://s3-eu-west-1.amazonaws.com/govuk-logstash-package-integration/logstash-1.1.9-monolithic.jar'
  } else {
    $logstash_jar_url = 'https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar'
    Govuk_mount['/srv'] -> Class['logstash']
    Govuk_mount['/srv'] -> Class['rsyslog::server']
  }

  curl::fetch { 'logstash-monolithic':
    source      => $logstash_jar_url,
    destination => '/var/tmp/logstash-1.1.9-monolithic.jar',
    require     => Class['govuk_java::oracle7::jre'],
  }

  # FIXME 20130605 @philippotter: the current version of the
  #   electrical/puppet-logstash module we're using (694fa1a) doesn't
  #   implement the anchor pattern properly. This has been fixed in
  #   5f104e3774 which is in version 0.3.0 of the module
  #   onwards. However 0.3.0 needs logstash 1.1.12, while we're
  #   currently using 1.1.9
  #
  # in practice this won't matter for existing machines, only when
  # provisioning a new machine.
  class { 'logstash':
    provider    => 'custom',
    jarfile     => 'file:///var/tmp/logstash-1.1.9-monolithic.jar',
    installpath => '/srv/logstash',
    initfile    => 'puppet:///modules/govuk/node/s_logging/logstash.init.Debian',
    require     => [
      Curl::Fetch['logstash-monolithic'],
    ],
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
    pattern   => [ '<%{POSINT:syslog_pri}>%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{PROG:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}' ],
    add_field => {
      'received_at'   => '%{@timestamp}',
      'received_from' => '%{@source_host}',
    },
    order     => '11',
  }
  logstash::filter::syslog_pri {'syslog':
    type  => 'syslog',
    order => '12',
  }
  logstash::filter::date {'syslog':
    type  => 'syslog',
    match => [ 'syslog_timestamp', 'MMM dd HH:mm:ss',
                'MMM  d HH:mm:ss' ],
    order => '13',
  }
  logstash::filter::mutate { 'logrus-msg-field':
    rename => {
      'msg' => '@message',
    },
  }
  logstash::filter::mutate {'syslog-1':
    type         => 'syslog',
    order        => '14',
    exclude_tags => [ '_grokparsefailure' ],
    replace      => {
      '@source_host' => '%{syslog_hostname}',
      '@message'     => '%{syslog_message}',
    },
  }
  logstash::filter::mutate {'syslog-2':
    type   => 'syslog',
    order  => '15',
    remove => [ 'syslog_hostname', 'syslog_message', 'syslog_timestamp' ],
  }

  #configure logstash outputs

  logstash::output::elasticsearch_http {'syslog':
    host  => 'logs-elasticsearch.cluster',
    index => 'logs-%{+YYYY.MM.dd}',
  }

  # Cronjob to zip old logs
  cron { 'compress-srv-logs':
    ensure  => present,
    user    => 'root',
    hour    => $compress_srv_logs_hour,
    minute  => '0',
    command => 'find /srv/log/2??? -mtime +28 -type f -exec gzip -q {} +',
  }

}
