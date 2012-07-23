class envmgr {
  file { '/etc/envmgr':
    ensure => directory;
  }

  package { 'envmgr':
    ensure   => '0.0.3',
    provider => 'pip';
  }
}
