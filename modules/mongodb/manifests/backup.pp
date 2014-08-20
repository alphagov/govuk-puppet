# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::backup(
  $domonthly = true
) {
  file { '/etc/cron.daily/automongodbbackup-replicaset':
    ensure  => present,
    content => template('mongodb/automongodbbackup'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => Class['mongodb::package'],
  }
}
