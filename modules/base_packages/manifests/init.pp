class base_packages {
  package {
    [
      'ack-grep',
      'build-essential',
      'curl',
      'daemontools',
      'gettext',
      'git-core',
      'less',
      'libcurl4-openssl-dev',
      'libreadline-dev',
      'libreadline5',
      'libsqlite3-dev',
      'libxml2-dev',
      'libxslt1-dev',
      'logtail',
      'tree',
      'vim-nox',
      'wget',
    ]:
    ensure => installed
  }
}
