class mongodb::backup(
  $domonthly = true) {
  file { '/etc/cron.daily/automongodbbackup-replicaset':
    ensure  => present,
    content => template('mongodb/automongodbbackup'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => Package['mongodb20-10gen'],
  }
}
