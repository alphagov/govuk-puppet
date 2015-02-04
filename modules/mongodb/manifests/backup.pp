# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::backup(
  $domonthly = true
) {
  $threshold_secs = 28 * 3600
  $service_desc = 'AutoMongoDB backup'

  file { '/etc/cron.daily/automongodbbackup-replicaset':
    ensure  => present,
    content => template('mongodb/automongodbbackup'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => Class['mongodb::package'],
  }

  @@icinga::passive_check { "check_automongodbbackup-${::hostname}":
    service_description => $service_desc,
    freshness_threshold => $threshold_secs,
    host_name           => $::fqdn,
  }

}
