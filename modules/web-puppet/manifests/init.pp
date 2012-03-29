class webpuppet(
  $port = '9295',
  $username = nil,
  $password = nil
) {

  package { 'web-puppet':
    ensure   => installed,
    provider => gem,
  }

  file { '/etc/web-puppet.conf':
    ensure  => present,
    content => template('web-puppet/web-puppet.conf'),
    notify  => Service['web-puppet'],
  }

  file { '/etc/init/web-puppet.conf':
    ensure  => present,
    source  => 'puppet:///modules/web-puppet/web-puppet',
  }

  service { 'web-puppet':
    ensure   => running,
    provider => upstart,
    require  => [
      Package['web-puppet'],
      File['/etc/init/web-puppet.conf'],
    ]
  }

}
