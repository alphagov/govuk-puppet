class base_packages::python {
  package {
    [
      'python',
      'python-dev',
      'python-setuptools',
      'python-pip',
    ]:
    ensure => installed
  }
}

define base_packages::python::pip_install() {
  exec { "pip install $name":
    command => "pip install $name",
    unless  => "pip freeze | grep $name",
    require => Package['python-pip'],
  }
}

class base_packages::unix_tools {
  package {
    [
      'less',
      'vim-nox',
      'tree',
      'curl',
      'gettext',
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

class base_packages {
  include base_packages::python
  include base_packages::unix_tools
}
