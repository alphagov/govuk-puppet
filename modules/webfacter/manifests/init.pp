class webfacter(
  $port = '9294',
  $username = false,
  $password = false
) {

  package { 'web-facter':
    ensure   => latest,
    provider => gem,
  }

  file { '/etc/web-facter.conf':
    ensure  => present,
    content => template('web-facter/web-facter.conf'),
    notify  => Service['web-facter'],
  }

  file { '/etc/init/web-facter.conf':
    ensure  => present,
    source  => 'puppet:///modules/web-facter/web-facter',
  }

  service { 'web-facter':
    ensure   => running,
    provider => upstart,
    require  => [
      Package['web-facter'],
      File['/etc/init/web-facter.conf'],
    ]
  }

}
