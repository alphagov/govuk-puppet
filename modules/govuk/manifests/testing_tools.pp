class govuk::testing_tools {
  include govuk::phantomjs

  package { [
    'qt4-qmake',     # needed for capybara-webkit
    'qt4-dev-tools', #    "            "
    'xvfb'
    ]:
    ensure => installed;
  }

  file { '/etc/init/xvfb.conf':
    ensure  => present,
    source  => 'puppet:///modules/govuk/xvfb.conf',
  }

  service { 'xvfb':
    ensure   => running,
    provider => upstart,
    require  => [
      Package['xvfb'],
      File['/etc/init/xvfb.conf'],
    ]
  }

}

class govuk::phantomjs {

  exec { 'download phantomjs':
    command => '/usr/bin/curl -o phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2 https://gds-public-readable-tarballs.s3.amazonaws.com/phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2',
    require => Package['curl'],
    timeout => 3600,
    unless  => '/usr/bin/test "`shasum phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2`" = "a1f6382265d1f0536e15f244f9a9b86804fc4318  phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2"'
  }

  exec { 'unpack phantomjs':
    require => Exec['download phantomjs'],
    creates => '/usr/local/src/phantomjs-1.6.1-linux-x86_64-dynamic',
    cwd     => '/usr/local/src',
    command => '/bin/tar -jxf ./phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2'
  }

  file { '/usr/local/bin/phantomjs':
    ensure  => link,
    target  => '/usr/local/src/phantomjs-1.6.1-linux-x86_64-dynamic/bin/phantomjs',
    require => [
      Exec['unpack phantomjs']
    ]
  }

  # No longer installed from a PPA

  package { 'phantomjs':
    ensure  => absent
  }

  apt::ppa_repository { 'jerome-etienne':
    ensure    => 'absent',
    publisher => 'jerome-etienne',
    repo      => 'neoip'
  }

}
