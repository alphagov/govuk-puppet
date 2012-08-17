define mapit::setup(
    $mapit_datadir = '/data/vhost/mapit') {
    group { 'mapit':
      ensure      => present,
      name        => 'mapit',
    }

    user { 'mapit':
      ensure      => present,
      home        => '/home/mapit',
      managehome  => true,
      shell       => '/bin/bash',
      gid         => 'mapit',
      require     => Group['mapit'],
    }

    file { '/data/vhost/mapit':
      ensure  => directory,
      owner   => 'mapit',
      group   => 'mapit',
      mode    => '0755',
      require => User['mapit'],
    }

    file { '/data/vhost/mapit/data':
      ensure  => directory,
      owner   => 'mapit',
      group   => 'mapit',
      mode    => '0755',
      require => User['mapit'],
    }
}
