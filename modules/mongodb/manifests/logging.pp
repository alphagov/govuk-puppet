# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::logging(
  $logpath
) {
  include logrotate

  file { $logpath:
    ensure => present,
    owner  => 'mongodb',
    group  => 'mongodb',
    mode   => '0644',
  }

  file { '/etc/logrotate.d/mongodb':
    ensure  => present,
    source  => 'puppet:///modules/mongodb/mongodb.logrotate',
    require => Class['logrotate'],
  }

  govuk::logstream { 'mongodb-logstream':
    logfile => $logpath,
    fields  => {'application' => 'mongodb'},
  }
}
