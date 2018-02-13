# == Class: collectd::plugin::icinga
#
# Monitors the number of Icinga alerts
#
class collectd::plugin::icinga(
) {

  @file { '/usr/lib/collectd/icinga.sh':
    ensure  => 'present',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => file('collectd/usr/lib/collectd/icinga.sh'),
    tag     => 'collectd::plugin',
    require => Class['collectd::package'],
  }

  @collectd::plugin { 'icinga':
    content => file('collectd/etc/collectd/conf.d/icinga.conf'),
    require => File['/usr/lib/collectd/icinga.sh'],
  }

}
