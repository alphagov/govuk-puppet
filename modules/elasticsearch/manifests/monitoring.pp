class elasticsearch::monitoring {
  include ganglia::client
  include nagios::client

  file { '/etc/ganglia/conf.d/elasticsearch.pyconf':
    source  => 'puppet:///modules/elasticsearch/elasticsearch.pyconf',
    require => [Service['elasticsearch'],Service['ganglia-monitor']]
  }

  file { '/usr/lib/ganglia/python_modules/elasticsearch.py':
    source  => 'puppet:///modules/elasticsearch/elasticsearch.py',
    mode    => '0755',
    require => [Service['elasticsearch'],Service['ganglia-monitor']]
  }

  file { '/etc/nagios/nrpe.d/check_elasticsearch.cfg':
    source  => 'puppet:///modules/elasticsearch/check_elasticsearch.cfg',
    mode    => '0755',
    require => [Service['elasticsearch'],Package['nagios-nrpe-server']],
    notify  => Service['nagios-nrpe-server']
  }

  @@nagios::check { "check_elasticsearch_running_${::hostname}":
    check_command       => 'check_nrpe!check_elastic',
    service_description => "check elasticsearch running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
