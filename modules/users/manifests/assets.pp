class users::assets {
  group { 'assets':
    ensure     => 'present',
    gid        => '2900',
  }

  user { 'assets':
    ensure     => 'present',
    home       => "/home/assets",
    shell      => '/bin/false',
    uid        => '2900',
    gid        => 'assets',
    require    => [Group['assets']],
  }
}