class graphite::package {

  include govuk::ppa

  package { [
    'python-flup',
    'python-txamqp',
    'python-simplejson'
  ]:
    ensure  => present,
  }

  package { 'python-whisper':
    ensure  => "0.9.10-1+r52-1ppa22~${::lsbdistcodename}1",
  }

  package { 'python-carbon':
    ensure  => "0.9.10-1+r245-1ppa25~${::lsbdistcodename}1",
  }

  package { 'python-graphite-web':
    ensure  => absent,
  }
  package { 'python-graphite':
    ensure  => "0.9.10-2+r845-1ppa31~${::lsbdistcodename}1",
    require => Package['python-graphite-web'],
  }

  file { '/var/log/graphite':
    ensure => directory,
  }

  file { '/opt/graphite':
    owner   => 'root',
    group   => 'root',
  }

}
