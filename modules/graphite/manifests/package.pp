class graphite::package {

  apt::repository { 'ubuntuus':
    url  => 'http://us.archive.ubuntu.com/ubuntu',
    repo => 'multiverse',
  }

  package { [
    'python-flup',
    'python-carbon',
    'python-graphite-web',
    'python-txamqp',
    'python-simplejson',
    'python-whisper'
  ]:
    ensure => present,
  }

  file { '/var/log/graphite':
    ensure => directory,
  }

  file { '/opt/graphite':
    owner   => 'root',
    group   => 'root',
    recurse => true,
  }

}
