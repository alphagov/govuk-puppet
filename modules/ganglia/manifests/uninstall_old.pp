class ganglia::uninstall_old {
  file { '/var/www/ganglia2':
    ensure  => absent,
    recurse => true,
    force   => true
  }
  package { 'ganglia-webfrontend':
    ensure  => 'purged',
    require => File['/var/www/ganglia2']
  }
}
