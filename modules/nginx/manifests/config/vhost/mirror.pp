define nginx::config::vhost::mirror ($aliases = []) {
  file { "/etc/nginx/sites-available/$name":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/mirror-vhost.conf'),
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }

  # @nagios::check for 5xx errors
  # cron for logster
  # graylogtail::collect for access and errors
  # htpasswd

  nginx::config::site { $name: }
  #nginx::config::ssl { $name: }
}

