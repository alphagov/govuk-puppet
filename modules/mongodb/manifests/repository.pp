class mongodb::repository {
  apt::repository { '10gen':
    url  => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
    key  => '7F0CEB10', # Richard Kreuter <richard@10gen.com>
    dist => 'dist',
    repo => '10gen',
  }
}
