class passenger(
  $mininstances = '1',
  $maxpoolsize = '6',
  $poolidletime = '300',
  $maxinstancesperapp = '0',
  $spawnmethod = 'smart-lv2'
) {

  include apt

  exec { 'apt-get-update-for-brightbox-ludic-repo':
    command     => '/usr/bin/apt-get update',
    refreshonly => true
  }

  exec { 'add-brightbox-apt-signing-key':
    command => '/usr/bin/wget http://apt.brightbox.net/release.asc -O - | /usr/bin/sudo /usr/bin/apt-key add -',
    unless  => '/usr/bin/sudo /usr/bin/apt-key list | /bin/grep 0090DAAD'
  }

  exec { 'add-brightbox-lucid-repo':
    command => '/usr/bin/wget -c http://apt.brightbox.net/sources/lucid/brightbox.list -P /etc/apt/sources.list.d/',
    notify  => Exec['apt-get-update-for-brightbox-ludic-repo'],
    require => Exec['add-brightbox-apt-signing-key'],
    creates => '/etc/apt/sources.list.d/brightbox.list'
  }

  package { 'libapache2-mod-passenger':
    ensure  => installed,
    require => [
      Exec['add-brightbox-lucid-repo'],
      Exec['apt_update'],
      Package['apache2']
    ]
  }

  package { 'passenger':
    ensure   => installed,
    provider => gem,
    require  => Package['libapache2-mod-passenger']
  }

  file { '/etc/apache2/mods-available/passenger.conf':
    ensure  => file,
    content => template('passenger/passenger.conf.erb'),
    require => Package['libapache2-mod-passenger'],
  }

  apache2::a2enmod { 'passenger': }

  File['/etc/apache2/mods-available/passenger.conf'] ~> Service['apache2']
}
