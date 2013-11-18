class nagios::config {

  include govuk::htpasswd
  include nagios::config::pingdom
  include nagios::config::smokey

  $app_domain = extlookup('app_domain','dev.gov.uk')

  # Used by graphite check templates, below
  $http_username = extlookup('http_username', '')
  $http_password = extlookup('http_password', '')

  file { '/etc/nagios3':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/nagios/etc/nagios3',
  }

  file { '/etc/nagios3/conf.d':
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    # FIXME: Remove this when we are sure that we have explicit file{}
    # resources for everything. It is confusing.
    source  => 'puppet:///modules/nagios/etc/nagios3/conf.d',
  }

  file { '/etc/nagios3/conf.d/check_graphite.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_graphite.cfg.erb'),
  }

  file { '/etc/nagios3/conf.d/check_graphite_metric_args.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_graphite_metric_args.cfg.erb'),
  }

  file { '/etc/nagios3/conf.d/check_http_nagios2.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_http_nagios2.cfg.erb'),
  }

  file { '/etc/nagios3/conf.d/check_mapit.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_mapit.cfg.erb'),
  }

  file { '/etc/nagios3/conf.d/check_whitehall_overdue.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_whitehall_overdue.cfg.erb'),
  }

  # Used by resource.cfg to insert links to correct monitoring instance into
  # emails.
  $monitoring_url = "https://nagios.${app_domain}/"

  file { '/etc/nagios3/resource.cfg':
    content  => template('nagios/resource.cfg.erb'),
  }

  file { '/etc/nagios-plugins':
    ensure => directory,
  }

  file { '/etc/nagios-plugins/config':
    ensure => directory,
  }

  file { '/etc/nagios-plugins/config/check_nrpe.cfg':
    source => 'puppet:///modules/nagios/etc/nagios-plugins/config/check_nrpe.cfg'
  }

  user { 'www-data':
    groups => ['nagios'],
  }

  cron { 'pagerduty':
    command => '/usr/local/bin/pagerduty_nagios.pl flush',
    user    => 'nagios',
    minute  => '*',
  }

}
