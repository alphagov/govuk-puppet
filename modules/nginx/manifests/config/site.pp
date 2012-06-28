define nginx::config::site() {
  file { "/etc/nginx/sites-enabled/$name":
    ensure  => link,
    target  => "/etc/nginx/sites-available/$name",
    require => File["/etc/nginx/sites-available/$name"],
    notify  => Exec['nginx_reload']
  }
}
