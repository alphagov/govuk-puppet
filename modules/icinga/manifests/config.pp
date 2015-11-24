# == Class: icinga::config
#
# Configuration for Icinga
#
# === Parameters
#
# [*http_username*]
#   Basic auth HTTP username
#
# [*http_password*]
#   Password for $http_username
#
class icinga::config (
  $http_username = '',
  $http_password = '',
) {

  include govuk::htpasswd
  include icinga::config::pingdom
  include icinga::config::smokey

  $app_domain = hiera('app_domain','dev.gov.uk')

  $check_graphite_command = '/usr/local/bin/check_graphite'

  file { '/etc/icinga':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/icinga/etc/icinga',
  }

  # FIXME: Remove once this file has been purged in production
  file { '/etc/icinga/htpasswd.users':
    ensure  => absent,
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
