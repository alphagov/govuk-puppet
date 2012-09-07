class datainsight::config::google_oauth {
  file {
    '/etc/gds':
      owner   => 'deploy',
      source  => 'puppet:///modules/datainsight/etc/gds',
      recurse => true,
      require => User['deploy'];
    '/var/lib/gds':
      owner   => 'deploy',
      source  => 'puppet:///modules/datainsight/var/lib/gds',
      recurse => true,
      require => User['deploy'];
  }
}