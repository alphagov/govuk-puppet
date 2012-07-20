class mysql::repository {
  include apt
  apt::deb_repository {'percona-repo':
    url      => 'http://repo.percona.com/apt',
    repo     => 'main',
    key_url  => 'http://gds-public-readable-tarballs.s3.amazonaws.com/percona-signing-key',
    key_name => 'percona-key'
  }
}
