define nginx::config::vhost::redirect($to) {
  notify { "random shizzle $name" : }
  file { "/etc/nginx/sites-available/$name":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/redirect-vhost.conf'),
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  notify { $name: }

  nginx::config::site { $name: }
  nginx::config::ssl { $name: }
}
