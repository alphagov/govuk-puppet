# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::logging {


  # FIXME: Remove once deployed to Production
  include logrotate
  file { '/var/log/mongodb':
    ensure  => absent,
    force   => true,
    recurse => true,
  }
  file { '/etc/logrotate.d/mongodb':
    ensure  => absent,
    require => Class['logrotate'],
  }
  # FIXME: End

  govuk::logstream { 'mongodb-logstream':
    logfile => '/var/log/upstart/mongodb.log',
    fields  => {'application' => 'mongodb'},
  }
}
