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

  # A bug in passenger means that apps using versions of versions of rack
  # other than the system version (due to a later version of rails, for example)
  # fail to load correctly.  Alex Tomlins realised this only occurs if a single
  # version of rack is installed to the system.  If multiple versions are
  # installed, the bug doesn't seem to be triggered.  So to get around this,
  # two (old) versions are installed.  Note, we can't use the puppet package declaration
  # to install these gems, as puppet doesn't allow two definitions with the same
  # name.  In any case, we don't want to interfere with any other rack declarations.

  exec {'install rack 1.0.0':
    command => 'gem install rack --no-rdoc --no-ri --version 1.0.0',
    unless  => 'gem list | grep "rack.*1.0.0"'
  }

  exec {'install rack 1.0.1':
    command => 'gem install rack --no-rdoc --no-ri --version 1.0.1',
    unless  => 'gem list | grep "rack.*1.0.1"'
  }

  apache2::a2enmod { 'passenger': }

  File['/etc/apache2/mods-available/passenger.conf'] ~> Service['apache2']
}
 