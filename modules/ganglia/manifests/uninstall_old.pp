class ganglia::uninstall_old {
  package { 'ganglia-webfrontend':
    ensure => 'purged'
  }
  file { '/var/www/ganglia2':
    ensure  => absent,
    recurse => true,
    force   => true
  }
}
