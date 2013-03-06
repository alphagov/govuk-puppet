class mongodb::backup {
  file { '/etc/cron.daily/automongodbbackup-replicaset':
    ensure  => present,
    source  => 'puppet:///modules/mongodb/automongodbbackup',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => Package['mongodb20-10gen'],
  }
}
