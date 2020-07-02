# == Class: govuk_solr::config
#
# Configures solr according to data.gov.uk needs.
# Includes custom schema.xml
#
# === Parameters
#
# [*jetty_user*]
#   Run Jetty as this user ID (default: solr)
#
# [*solr_home*]
#   The home directory for solr.
#
class govuk_solr::config (
  $jetty_user = undef,
  $solr_home = undef,
  $remove = undef,
) {

  $ensure_dir = $remove ? {
    false => directory,
    true  => absent,
  }

  $ensure_file = $remove ? {
    false => file,
    true  => absent,
  }

  $ensure_service = $remove ? {
    false => running,
    true  => stopped,
  }

  file{"${solr_home}/current/conf":
    ensure  => $ensure_dir,
  } ->

  file{"${solr_home}/current/solr":
    ensure  => $ensure_dir,
    owner   => $jetty_user,
    group   => $jetty_user,
    recurse => true,
  } ->

  file {"${solr_home}/current/example/solr/collection1/conf/schema.xml":
    ensure => $ensure_file,
    owner  => $jetty_user,
    group  => $jetty_user,
    source => 'puppet:///modules/govuk_solr/schema.xml',
    notify => Service['jetty'],
  } ->

  file {"${solr_home}/current/conf/jetty-logging.xml":
    ensure => $ensure_file,
    owner  => $jetty_user,
    group  => $jetty_user,
    source => 'puppet:///modules/govuk_solr/jetty-logging.xml',
    notify => Service['jetty'],
  } ->

  file {'/etc/default/jetty':
    ensure  => $ensure_file,
    content => template('govuk_solr/jetty.erb'),
    notify  => Service['jetty'],
  } ->

  file {'/etc/init.d/jetty':
    ensure  => $ensure_file,
    mode    => '0755',
    content => template('govuk_solr/jetty.sh.erb'),
    notify  => Service['jetty'],
  } ->

  file {'/var/log/jetty':
    ensure => $ensure_dir,
  } ->

  file {'/var/cache/jetty':
    ensure => $ensure_dir,
  } ->

  service {'jetty':
    ensure => $ensure_service,
  }
}
