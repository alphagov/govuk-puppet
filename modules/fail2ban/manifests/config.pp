# == Class: fail2ban::config
#
# This class sets up fail2ban configuration.
#
# === Parameters
#
# [*whitelist*]
#   An array IP addresses, CIDR masks or DNS hostnames
#
class fail2ban::config(
  $whitelist = []
) {

  file { '/etc/fail2ban/fail2ban.local':
    source => 'puppet:///modules/fail2ban/etc/fail2ban/fail2ban.local',
  }

  file { '/etc/fail2ban/jail.local':
    content => template('fail2ban/etc/fail2ban/jail.local.erb'),
  }

  Fail2ban::Config::Jail_snippet <| |>
}
