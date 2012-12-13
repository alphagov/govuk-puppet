class nagios::config ($platform = $::govuk_platform) {

  include govuk::htpasswd

  $domain = extlookup('app_domain')
  $vhost = "nagios.${domain}"

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
  $monitoring_url = "https://${vhost}/"

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
