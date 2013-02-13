class resolvconf::package {
  package { 'resolvconf':
    ensure => present,
  }
}
