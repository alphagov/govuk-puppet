class nagios::config {

  include govuk::htpasswd

  $app_domain = extlookup('app_domain','dev.gov.uk')
  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))

  # Used by graphite check templates, below
  $http_username = extlookup('http_username', '')
  $http_password = extlookup('http_password', '')

  # Used by vhost templates and $monitoring_url below.
  $vhost = 'nagios'

  nginx::config::ssl { $vhost: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost:
    content => template('nagios/nginx.conf.erb'),
  }

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
    source  => 'puppet:///modules/nagios/etc/nagios3/conf.d',
  }

  file { '/etc/nagios3/conf.d/check_graphite.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_graphite.cfg.erb'),
  }

  file { '/etc/nagios3/conf.d/check_graphite_metric_since.cfg':
    content => template('nagios/etc/nagios3/conf.d/check_graphite_metric_since.cfg.erb'),
  }

  # Used by resource.cfg to insert links to correct monitoring instance into
  # emails.
  $monitoring_url = "https://${vhost}.${app_domain}/"

  file { '/etc/nagios3/resource.cfg':
    content  => template('nagios/resource.cfg.erb'),
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
