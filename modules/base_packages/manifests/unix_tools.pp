class base_packages::unix_tools {
  package {
    [
      'less',
      'vim-nox',
      'tree',
      'curl',
      'gettext',
      'ack-grep',
      'daemontools',
      'git-core',
      'build-essential',
      'libxml2-dev',
      'libxslt1-dev',
      'libsqlite3-dev',
      'libreadline-dev',
      'libreadline5',
      'unattended-upgrades',
      'libcurl4-openssl-dev',
      'logtail',
    ]:
    ensure => installed
  }

  file { '/etc/apt/apt.conf.d/10periodic':
    ensure  => present,
    source  => 'puppet:///modules/base_packages/10periodic',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['unattended-upgrades'],
  }

  file { '/etc/apt/apt.conf.d/50unattended-upgrades':
    ensure  => present,
    source  => 'puppet:///modules/base_packages/50unattended-upgrades',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['unattended-upgrades'],
  }
}
