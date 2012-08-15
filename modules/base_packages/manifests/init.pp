class base_packages {
  package {
    [
      'ack-grep',
      'bzip2',
      'build-essential',
      'libc6-dev',
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
      'tar',
      'tree',
      'unzip',
      'vim-nox',
      'wget',
      'xz-utils'
    ]:
    ensure => installed
  }
}
