class nginx::service {

  service { 'nginx':
    ensure     => running,
    hasstatus  => true,
    restart    => '/etc/init.d/nginx reload',
  }

}
