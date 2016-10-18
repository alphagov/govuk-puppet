# == Class: collectd::plugin::file_handles
#
# Monitors the number of file handles in use on a system
#
class collectd::plugin::file_handles(
) {

  @file { '/usr/lib/collectd/file_handles.sh':
    ensure  => 'present',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => file('collectd/usr/lib/collectd/file_handles.sh'),
    tag     => 'collectd::plugin',
    require => Class['collectd::package'],
  }

  @collectd::plugin { 'file_handles':
    content => template('collectd/etc/collectd/conf.d/file_handles.conf.erb'),
    require => File['/usr/lib/collectd/file_handles.sh'],
  }

}
