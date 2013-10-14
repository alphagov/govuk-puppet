class mongodb::repository {
  apt::source { '10gen':
    location => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
    key      => '7F0CEB10', # Richard Kreuter <richard@10gen.com>
    release  => 'dist',
    repos    => '10gen',
  }
}
