class assets {
  include assets::user

  package { 'nfs-common':
    ensure => installed,
  }

  file { "/data/uploads":
    ensure  => 'directory',
    owner   => 'assets',
    group   => 'assets',
    mode    => '0664',
    require => [User['assets'], Group['assets']],
  }
}
