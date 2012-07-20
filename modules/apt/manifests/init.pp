class apt {
  include apt::update

  file { 'sources.list':
    ensure => present,
    name   => '/etc/apt/sources.list',
    owner  => root,
    group  => root,
    mode   => '0644';
  }

  file { 'sources.list.d':
    ensure => directory,
    name   => '/etc/apt/sources.list.d',
    owner  => root,
    group  => root;
  }

  package { 'python-software-properties':
    ensure => installed;
  }

}
