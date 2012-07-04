class govuk::testing_tools {
  include govuk::phantomjs

  package { 'xvfb':
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

  package { 'phantomjs':
    ensure  => absent
  }

  exec { 'download phantomjs':
    command => '/usr/bin/curl -o phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2 https://gds-public-readable-tarballs.s3.amazonaws.com/phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2',
    require => Package['curl'],
    timeout => 3600,
    unless  => '/usr/bin/test "`shasum phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2`" = "b429c15007e1ddcb43dfbb4b4b72f3e22906aad2  phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2"'
  }

  exec { 'unpack phantomjs':
    require => Exec['download phantomjs'],
    creates => '/usr/local/src/phantomjs-1.6.0-linux-x86_64-dynamic',
    cwd     => '/usr/local/src',
    command => '/bin/tar -jxf ./phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2'
  }

  file { '/usr/local/bin/phantomjs':
    ensure  => link,
    target  => '/usr/local/src/phantomjs-1.6.0-linux-x86_64-dynamic/bin/phantomjs',
    require => [
      Exec['unpack phantomjs'],
      Apt::Ppa_repository['jerome-etienne']
    ]
  }

  apt::ppa_repository { 'jerome-etienne':
    ensure    => 'absent',
    publisher => 'jerome-etienne',
    repo      => 'neoip'
  }

}
