define nginx::vhost::redirect($to) {
  file { "/etc/nginx/sites-available/$name":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/redirect-vhost.conf'),
    require => Class['nginx::install'],
    notify  => Exec['nginx_reload'],
  }

  nginx::site { $name: }
  nginx::ssl { $name: }
}
