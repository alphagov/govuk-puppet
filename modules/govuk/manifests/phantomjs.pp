class govuk::phantomjs {

  exec { 'download phantomjs':
    command => '/usr/bin/curl -o phantomjs-1.8.1-linux-x86_64.tar.bz2 https://gds-public-readable-tarballs.s3.amazonaws.com/phantomjs-1.8.1-linux-x86_64.tar.bz2',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/phantomjs-1.8.1-linux-x86_64.tar.bz2',
    require => Package['curl'],
    timeout => 3600,
    unless  => '/usr/bin/test "`shasum phantomjs-1.8.1-linux-x86_64.tar.bz2`" = "8fb1420d633c24092d01a34eaa8c8c9e89d21d0a phantomjs-1.8.1-linux-x86_64.tar.bz2"'
  }

  exec { 'unpack phantomjs':
    require => Exec['download phantomjs'],
    creates => '/usr/local/src/phantomjs-1.8.1-linux-x86_64',
    cwd     => '/usr/local/src',
    command => '/bin/tar -jxf ./phantomjs-1.8.1-linux-x86_64.tar.bz2'
  }

  file { '/usr/local/bin/phantomjs':
    ensure  => link,
    target  => '/usr/local/src/phantomjs-1.8.1-linux-x86_64/bin/phantomjs',
    require => [
      Exec['unpack phantomjs']
    ]
  }

  # No longer installed from a PPA

  package { 'phantomjs':
    ensure  => absent
  }

  package { 'libfontconfig1':
    ensure => present
  }

}