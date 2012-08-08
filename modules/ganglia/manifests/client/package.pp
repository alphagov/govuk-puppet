class ganglia::client::package {
  package { 'ganglia-monitor':
    ensure => present,
  }
}
