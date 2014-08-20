# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::config {

  include govuk::htpasswd
  include icinga::config::pingdom
  include icinga::config::smokey

  $app_domain = hiera('app_domain','dev.gov.uk')

  # Used by graphite check templates, below
  $http_username = hiera('http_username', '')
  $http_password = hiera('http_password', '')

  file { '/etc/icinga':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/icinga/etc/icinga',
  }

  file { '/etc/icinga/conf.d':
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    # FIXME: Remove this when we are sure that we have explicit file{}
    # resources for everything. It is confusing.
    source  => 'puppet:///modules/icinga/etc/icinga/conf.d',
  }

  file { '/etc/icinga/conf.d/check_graphite.cfg':
    content => template('icinga/check_graphite.cfg.erb'),
  }

  file { '/etc/icinga/conf.d/check_graphite_metric_args.cfg':
    content => template('icinga/check_graphite_metric_args.cfg.erb'),
  }

  file { '/etc/icinga/conf.d/check_http_icinga.cfg':
    content => template('icinga/check_http_icinga.cfg.erb'),
  }

  file { '/etc/icinga/conf.d/check_mapit.cfg':
    content => template('icinga/check_mapit.cfg.erb'),
  }

  # Used by resource.cfg to insert links to correct monitoring instance into
  # emails.
  $monitoring_url = "https://icinga.${app_domain}/"

  file { '/etc/icinga/resource.cfg':
    content  => template('icinga/resource.cfg.erb'),
  }

  file { '/etc/nagios-plugins':
    ensure => directory,
  }

  file { '/etc/nagios-plugins/config':
    ensure => directory,
  }

  file { '/etc/nagios-plugins/config/check_nrpe.cfg':
    source => 'puppet:///modules/icinga/etc/nagios-plugins/config/check_nrpe.cfg'
  }

  user { 'www-data':
    groups => ['nagios'],
  }

  cron { 'pagerduty':
    command => '/usr/local/bin/pagerduty_icinga.pl flush',
    user    => 'nagios',
    minute  => '*',
  }

}
