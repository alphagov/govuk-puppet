class phantomjs {
  include govuk::repository

  exec { 'download phantomjs':
    command => '/usr/bin/curl -o phantomjs-1.9.7-linux-x86_64.tar.bz2 https://gds-public-readable-tarballs.s3.amazonaws.com/phantomjs-1.9.7-linux-x86_64.tar.bz2',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/phantomjs-1.9.7-linux-x86_64.tar.bz2',
    require => Package['curl'],
    timeout => 3600,
    unless  => '/usr/bin/test "`shasum phantomjs-1.9.7-linux-x86_64.tar.bz2`" = "ca3581dfdfc22ceab2050cf55ea7200c535a7368 phantomjs-1.9.7-linux-x86_64.tar.bz2"'
  }

  exec { 'unpack phantomjs':
    require => Exec['download phantomjs'],
    creates => '/usr/local/src/phantomjs-1.9.7-linux-x86_64',
    cwd     => '/usr/local/src',
    command => '/bin/tar -jxf ./phantomjs-1.9.7-linux-x86_64.tar.bz2'
  }

  file { '/usr/local/bin/phantomjs':
    ensure  => link,
    target  => '/usr/local/src/phantomjs-1.9.7-linux-x86_64/bin/phantomjs',
    require => Exec['unpack phantomjs'],
  }

  package { 'libfontconfig1':
    ensure => present,
  }

}
