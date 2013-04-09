class puppet::master::config ($unicorn_port = '9090') {
  nginx::config::site { 'puppetmaster':
    content => template('puppet/puppetmaster-vhost.conf'),
  }
  nginx::log {
    'puppetmaster-json.event.access.log':
      json      => true,
      logstream => true;
    'puppetmaster-access.log':
      logstream => false;
    'puppetmaster-error.log':
      logstream => true;
  }

  @logster::cronjob { "nginx-vhost-puppetmaster":
    file    => '/var/log/nginx/puppetmaster-access.log',
    prefix  => 'nginx_logs.puppetmaster',
  }

  # FIXME: keepLastValue() because logster only runs every 2m.
  @@nagios::check { "check_nginx_5xx_puppetmaster_on_${::hostname}":
    check_command       => "check_graphite_metric_since!keepLastValue(${::fqdn_underscore}.nginx_logs.puppetmaster.http_5xx)!3minutes!0.05!0.1",
    service_description => "puppetmaster nginx high 5xx rate",
    host_name           => $::fqdn,
  }

  file { '/etc/puppet/config.ru':
    require => Exec['install rack 1.0.1'],
    source  => 'puppet:///modules/puppet/etc/puppet/config.ru'
  }


  @logrotate::conf { "puppetmaster":
    matches => "/var/log/puppetmaster/*.log",
  }

  file {'/etc/puppet/unicorn.conf':
    source => "puppet:///modules/puppet/etc/puppet/unicorn.conf",
  }
  file {'/etc/puppet/puppetdb.conf':
    content => template('puppet/etc/puppet/puppetdb.conf.erb'),
  }
  file {'/etc/puppet/routes.yaml':
    source => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
  }
  file { '/usr/local/bin/puppet_config_version':
    ensure  => present,
    source  => 'puppet:///modules/puppet/usr/local/bin/puppet_config_version',
    mode    => '0755',
  }
}
