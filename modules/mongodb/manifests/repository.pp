class mongodb::repository {
  include apt
  include mongodb::signing_key
  apt::deb_repository { '10gen':
    url     => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
    dist    => 'dist',
    repo    => '10gen',
    require => Class['mongodb::signing_key'],
  }
}
