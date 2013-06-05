class mongodb::config ($replicaset = $govuk_platform, $dbpath = '/var/lib/mongodb') {

  # $dbpath and $replicaset are both used by the templates below

  $mongod_log_file = '/var/log/mongodb/mongod.log'

  file { '/etc/mongodb.conf':
    ensure  => present,
    content => template('mongodb/mongodb.conf'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/var/log/mongodb/mongod.log':
    ensure  => present,
    owner   => 'mongodb',
    group   => 'mongodb',
    mode    => '0644',
  }

  file { '/etc/init/mongodb.conf':
    ensure  => present,
    content => template('mongodb/upstart-standalone.conf'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
