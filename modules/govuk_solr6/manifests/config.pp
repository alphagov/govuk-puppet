# == Class: govuk_solr::config
#
# Configures solr according to data.gov.uk needs.
#
# === Parameters
#
# [*solr_home*]
#   The home directory for solr.
#
# [*solr_host*]
#   "control the hostname exposed to cluster"
#
# [*solr_install_dir*]
#   Where the solr code will be installed
#
# [*solr_log_dir*]
#   Log directory
#
# [*solr_pid_dir*]
#   Directory to keep pidfiles
#
# [*solr_port*]
#   Port for solr to listen on
#
# [*solr_user*]
#   User name to run solr as
#
class govuk_solr6::config (
  $solr_home = undef,
  $solr_host = undef,
  $solr_install_dir = undef,
  $solr_log_dir = undef,
  $solr_pid_dir = undef,
  $solr_port = undef,
  $solr_user = undef,
) {

  file {'/etc/default/solr.in.sh':
    ensure  => file,
    content => template('govuk_solr/solr.in.sh.erb'),
    notify  => Service['solr'],
  } ->

  file {'/etc/init.d/solr':
    ensure  => file,
    mode    => '0755',
    content => template('govuk_solr/init.solr.erb'),
    notify  => Service['solr'],
  } ->

  file {$solr_log_dir:
    ensure => directory,
    notify => Service['solr'],
  } ->

  file {$solr_pid_dir:
    ensure => directory,
    notify => Service['solr'],
  } ->

  service {'solr':
    ensure => running,
  }
}
