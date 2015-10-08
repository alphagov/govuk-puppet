# == Class icinga::graphite_contact
#
# Graph Icinga alerts in Graphite.
#
define icinga::graphite_contact (
) {

  file {'/usr/local/bin/notify_graphite':
    content => template('icinga/notify_graphite.erb'),
    mode    => '0755',
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

  file {'/etc/icinga/conf.d/contact_graphite.cfg':
    content => template('icinga/graphite_contact.cfg.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
