# == Class: Icinga::client::config
#
# Configure NRPE (an Icinga client) and its various runners.
#
# === Parameters
#
# [*allowed_hosts*]
#   A string of comma-separated hostnames, IPs or CIDR blocks which are
#   allowed to talk to the NRPE daemon.
#
#   Default: 'alert.cluster,monitoring'
#
class icinga::client::config (
  $allowed_hosts = 'alert.cluster,monitoring',
) {

  file { '/etc/nagios/nrpe.cfg':
    content => template('icinga/etc/nagios/nrpe.cfg.erb'),
    mode    => '0640',
  }

  file { '/usr/local/bin/nrpe-runner':
    source => 'puppet:///modules/icinga/usr/local/bin/nrpe-runner',
    mode   => '0755',
  }

  file { '/etc/nagios/nrpe.d':
    ensure  => directory,
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d',
    recurse => true,
    purge   => true,
    force   => true,
  }

}
