# == Define: govuk_bundler::bundler
#
# Manage the config used by bundler for access to gemstash.
#
# === Parameters
#
# [*user_home*]
#   The home directory of the user to add the config to.
#   Default: /home/deploy
#
# [*server*]
#   The gemstash server to use
#   Default: http://gemstash.cluster
#
define govuk_bundler::config(
  $user_home,
  $server = 'http://gemstash.cluster',
) {
  file { "${user_home}/.bundle":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  file { "${user_home}/.bundle/config":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('govuk_bundler/bundle_config.erb'),
  }
}
