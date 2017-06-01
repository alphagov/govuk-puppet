# == Define: govuk_bundler::bundler
#
# Manage the config used by bundler for access to gemstash.
#
# === Parameters
#
# [*user_home*]
#   The home directory of the user to add the config to.
# [*username*]
#   The name of the user where we will add the directories to.
#
# [*server*]
#   The gemstash server to use
#   Default: http://gemstash.cluster
#
define govuk_bundler::config(
  $user_home,
  $username,
  $server = 'http://gemstash.cluster',
) {
  file { "${user_home}/.bundle":
    ensure => 'directory',
    owner  => $username,
    group  => $username,
  }

  file { "${user_home}/.bundle/cache":
    ensure => 'directory',
    owner  => $username,
    group  => $username,
  }

  file { "${user_home}/.bundle/config":
    ensure  => 'present',
    owner   => $username,
    group   => $username,
    mode    => '0644',
    content => template('govuk_bundler/bundle_config.erb'),
  }
}
