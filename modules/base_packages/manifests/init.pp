class base_packages {
  package {
    [
      'ack-grep',
      'bzip2',
      'build-essential',
      'curl',
      'gettext',
      'git-core',
      'htop',
      'iotop',
      'iptraf',
      'less',
      'libc6-dev',
      'libcurl4-openssl-dev',
      'libreadline-dev',
      'libreadline5',
      'libsqlite3-dev',
      'libxml2-dev',
      'libxslt1-dev',
      'logtail',
      'pv',
      'tar',
      'tree',
      'unzip',
      'vim-nox',
      'xz-utils',
      'zip'
    ]:
    ensure => installed
  }

  case $::lsbdistcodename {
    'precise': {
        package{
          [
            'ruby1.9.1-dev',
          ]:
            ensure => installed,
        }
        include nodejs
    }
    default: {}
  }

}
