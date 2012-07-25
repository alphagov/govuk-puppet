define nginx::config::vhost::dev_proxy($to, $aliases = []) {
  file { "/etc/nginx/sites-available/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/dev-proxy-vhost.conf'),
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  nginx::config::site { "$name": }
}
