class mongodb::config (
  $replicaset = $govuk_platform,
  $dbpath = '/var/lib/mongodb',
  $logpath,
  $development
) {

  # Class params are used in the templates below.

  file { '/etc/mongodb.conf':
    ensure  => present,
    content => template('mongodb/mongodb.conf'),
    owner   => 'root',
    group   => 'root',
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
