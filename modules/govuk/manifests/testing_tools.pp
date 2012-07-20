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

  exec { 'download phantomjs':
    command => '/usr/bin/curl -o phantomjs-1.5.0-linux-x86_64-dynamic.tar.gz https://gds-public-readable-tarballs.s3.amazonaws.com/phantomjs-1.5.0-linux-x86_64-dynamic.tar.gz',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/phantomjs-1.5.0-linux-x86_64-dynamic.tar.gz',
    require => Package['curl'],
    timeout => 3600,
    unless  => '/usr/bin/test "`shasum phantomjs-1.5.0-linux-x86_64-dynamic.tar.gz`" = "137113dbb25dcd7cf4e19f70c05c11ed8f258b24  phantomjs-1.5.0-linux-x86_64-dynamic.tar.gz"'
  }

  exec { 'unpack phantomjs':
    require => Exec['download phantomjs'],
    creates => '/usr/local/src/phantomjs-1.5.0-linux-x86_64-dynamic',
    cwd     => '/usr/local/src',
    command => '/bin/tar --transform=\'s/^phantomjs/phantomjs-1.5.0-linux-x86_64-dynamic/\' -zxf ./phantomjs-1.5.0-linux-x86_64-dynamic.tar.gz'
  }

  file { '/usr/local/bin/phantomjs':
    ensure  => link,
    target  => '/usr/local/src/phantomjs-1.5.0-linux-x86_64-dynamic/bin/phantomjs',
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
