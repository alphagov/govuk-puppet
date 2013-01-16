class screen {

  package { 'screen':
    ensure => present,
  }

  file { '/etc/screenrc':
    ensure => present,
    source => 'puppet:///modules/screen/screenrc',
  }

}
