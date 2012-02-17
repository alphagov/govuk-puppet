class nginx {
  include logster
  include graylogtail

  exec { 'nginx_reload':
    command     => "/etc/init.d/nginx reload",
    refreshonly => true,
    onlyif      => "/etc/init.d/nginx configtest",
  }

  define nxensite() {
    file { "/etc/nginx/sites-enabled/$name":
      ensure => link,
      target => "/etc/nginx/sites-available/$name",
      require => File["/etc/nginx/sites-available/$name"],
      notify => Exec['nginx_reload']
    }
  }

  include nginx::install
  include nginx::service
}

class nginx::install {
  include apt
  apt::ppa_repository { "nginx_ppa":
    publisher => "nginx",
    repo      => "stable",
  }
  package { "nginx":
    require => Exec["add_repo_nginx_ppa"],
    ensure => "1.0.11-1ppa1~lucid",
  }
  file { '/etc/nginx/nginx.conf':
    ensure => file,
    source => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify => Exec['nginx_reload'],
  }
  file { '/etc/nginx/blockips.conf':
    ensure => file,
    source => 'puppet:///modules/nginx/blockips.conf',
    require => Package['nginx'],
    notify => Exec['nginx_reload'],
  }
  file { ['/var/www', '/var/www/cache']:
    ensure => directory,
    owner => 'www-data',
  }
  file { "/usr/share/nginx/www":
    ensure => directory,
    mode  => 0777,
  }
  file { '/etc/nginx/htpasswd':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => 0755,
    require => Package['nginx']
  }
  file { "/etc/nginx/ssl":
    ensure => directory
  }
}

class nginx::service {
  service { "nginx":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Class["nginx::install"],
  }

}

class nginx::demo {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure => file,
    source => 'puppet:///modules/nginx/demo',
    require => Class['nginx::install'],
  }
  file { '/etc/nginx/htpasswd':
    ensure => file,
    source => 'puppet:///modules/nginx/htpasswd',
    require => Class['nginx::install'],
  }

  File['/etc/nginx/sites-enabled/default'] ~> Service['nginx']
}

class nginx::development {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => 'puppet:///modules/nginx/development',
    require => Class['nginx::install'],
  }

  File['/etc/nginx/sites-enabled/default'] ~> Service['nginx']
}

class nginx::router {
  include nginx
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source => "puppet:///modules/nginx/router_$govuk_platform",
    require => Class['nginx::install'],
    notify => Exec['nginx_reload'],
  }
  file { '/etc/htpasswd':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.default',
    require => Class['nginx::install'],
    notify => Exec['nginx_reload'],
  }
  file { '/etc/nginx/htpasswd/htpasswd.whitehall':
    ensure => file,
    source => 'puppet:///modules/nginx/htpasswd.whitehall',
    require => Class['nginx::install'],
    notify => Exec['nginx_reload'],
  }
  if $govuk_platform == 'production' {
    $host = "www.gov.uk"
  } else {
    $host = "www.$govuk_platform.alphagov.co.uk"
  }
  file { "/etc/nginx/ssl/$host.crt":
    ensure  => present,
    content => extlookup("${host}_crt"),
  }
  file { "/etc/nginx/ssl/$host.key":
    ensure  => present,
    content => extlookup("${host}_key"),
  }
  @@nagios_service { "check_nginx_5xx_on_${hostname}":
    use                 => "generic-service",
    check_command       => "check_ganglia_metric!nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate",
    host_name           => "${govuk_class}-${hostname}",
    target              => "/etc/nagios3/conf.d/nagios_service.cfg",
  }
  cron { "logster-nginx":
    command => "/usr/sbin/logster NginxGangliaLogster /var/log/nginx/lb-access.log",
    user => root,
    minute => '*/2'
  }
  graylogtail::collect { "graylogtail-access":
    log_file => "/var/log/nginx/lb-access.log",
    facility => $name,
  }
  graylogtail::collect { "graylogtail-errors":
    log_file => "/var/log/nginx/lb-error_log",
    facility => $name,
    level    => "error",
  }
  file { '/var/www/fallback':
    ensure => directory,
    owner  => "deploy",
    group  => "deploy",
  }
  file { '/var/www/fallback/fallback_holding.html':
    ensure  => file,
    source  => 'puppet:///modules/nginx/fallback.html',
    owner  => "deploy",
    group  => "deploy",
  }
}

class nginx::vhost {

  define redirect($to) {
    file { "/etc/nginx/sites-available/$name":
      owner => "root",
      group => "root",
      mode => 0644,
      content => template('nginx/redirect-vhost.conf'),
      require => Class["nginx::install"],
      notify => Exec['nginx_reload'],
    }

    nxensite { $name: }
    nginx::vhost::ssl { $name: }
  }

  define ssl() {
    if $name == "www.gov.uk" {
      $cert = $name
    } elsif $name == "www.preview.alphagov.co.uk" {
      $cert = $name
    } else {
      $cert = "static.${govuk_platform}.alphagov.co.uk"
    }
    file { "/etc/nginx/ssl/$name.crt":
      ensure  => present,
      content => extlookup("${cert}_crt")
    }
    file { "/etc/nginx/ssl/$name.key":
      ensure  => present,
      content => extlookup("${cert}_key")
    }
  }

  define proxy($to, $aliases = [], $protected = true, $ssl_only = false) {
    file { "/etc/nginx/sites-available/$name":
      owner => "root",
      group => "root",
      mode => 0644,
      content => template('nginx/proxy-vhost.conf'),
      require => Class["nginx::install"],
      notify => Exec['nginx_reload'],
    }

    @@nagios_service { "check_nginx_5xx_${name}_on_${hostname}":
      use           => "generic-service",
      check_command => "check_ganglia_metric!${name}_nginx_http_5xx!0.05!0.1",
      service_description => "check nginx error rate for ${name}",
      host_name     => "${govuk_class}-${hostname}",
      target        => "/etc/nagios3/conf.d/nagios_service.cfg",
    }

    cron { "logster-nginx-$name":
      command => "/usr/sbin/logster --metric-prefix $name NginxGangliaLogster /var/log/nginx/${name}-access_log",
      user => root,
      minute => '*/2'
    }

    graylogtail::collect { "graylogtail-access-$name":
      log_file => "/var/log/nginx/${name}-access_log",
      facility => $name,
    }
    graylogtail::collect { "graylogtail-errors-$name":
      log_file => "/var/log/nginx/${name}-error_log",
      facility => $name,
      level    => "error",
    }

    case $protected {
      default: {
        file { "/etc/nginx/htpasswd/htpasswd.$name":
          ensure => present,
          source => [
            "puppet:///modules/nginx/htpasswd.$name",
            "puppet:///modules/nginx/htpasswd.backend",
            "puppet:///modules/nginx/htpasswd.default"
          ],
        }
      }
      false: {
        file { "/etc/nginx/htpasswd/htpasswd.$name":
          ensure => absent
        }
      }
    }

    nginx::vhost::ssl { $name: }
    nxensite { $name: }
  }

  define static($protected = true, $aliases = [], $ssl_only = false) {
    file { "/etc/nginx/sites-available/$name":
      owner => "root",
      group => "root",
      mode => 0644,
      content => template('nginx/static-vhost.conf'),
      require => Class["nginx::install"],
      notify => Exec['nginx_reload'],
    }

    case $protected {
      default: {
        file { "/etc/nginx/htpasswd/htpasswd.$name":
          ensure => present,
          source => [
            "puppet:///modules/nginx/htpasswd.$name",
            "puppet:///modules/nginx/htpasswd.backend",
            "puppet:///modules/nginx/htpasswd.default"
          ],
        }
      }
      false: {
        file { "/etc/nginx/htpasswd/htpasswd.$name":
          ensure => absent
        }
      }
    }

    nginx::vhost::ssl { $name: }
    nxensite { $name: }
  }
}
