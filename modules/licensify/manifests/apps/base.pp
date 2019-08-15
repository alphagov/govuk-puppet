# == Class: licensify::apps::base
#
# Base class for Licensify (GOV.UK Licensing) apps.
#
class licensify::apps::base {

  file { '/etc/licensing':
    ensure => directory,
    mode   => '0755',
    owner  => 'deploy',
    group  => 'deploy',
  }
}
