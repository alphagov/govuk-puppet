class nginx::config($node_type) {
  exec { 'nginx_reload':
    command     => '/etc/init.d/nginx reload',
    refreshonly => true,
    onlyif      => '/etc/init.d/nginx configtest',
  }
  exec { 'nginx_restart':
    command     => '/etc/init.d/nginx restart',
    refreshonly => true,
    onlyif      => '/etc/init.d/nginx configtest',
  }

  file { '/etc/nginx':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/nginx/etc/nginx';
  }
  file { ['/etc/nginx/sites-enabled', '/etc/nginx/sites-available']:
    ensure  => directory,
    recurse => true, # enable recursive directory management
    purge   => true, # purge all unmanaged junk
    force   => true, # also purge subdirs and links etc.
    require => File['/etc/nginx'];
  }
  file { ['/var/www', '/var/www/cache']:
    ensure => directory,
    owner  => 'www-data',
  }

  file { '/usr/share/nginx':
    ensure  => directory,
  }
  file { '/usr/share/nginx/www':
    ensure  => directory,
    mode    => '0755',
    require => File['/usr/share/nginx'];
  }

  @logstash::collector { 'nginx':
    source  => 'puppet:///modules/nginx/etc/logstash/logstash-client/nginx.conf',
  }

  @ganglia::cronjob { 'nginx-status':
    source => 'puppet:///modules/nginx/nginx_ganglia2.sh',
    minute => '*/2',
  }

  case $node_type {
    router : {
      @@nagios::check { "check_nginx_active_connections_${::hostname}":
        check_command       => 'check_ganglia_metric!nginx_active_connections!1000!2000',
        service_description => 'check nginx active connections',
        host_name           => "${::govuk_class}-${::hostname}",
      }
    }
    default : {
      @@nagios::check { "check_nginx_active_connections_${::hostname}":
        check_command       => 'check_ganglia_metric!nginx_active_connections!500!1000',
        service_description => 'check nginx active connections',
        host_name           => "${::govuk_class}-${::hostname}",
      }
    }
  }

  case $node_type  {
    redirect:          { include nginx::config::redirect }
    frontend_server:   { }
    backend_server:    { }
    development:       { include nginx::config::development }
    router:            { include nginx::config::router }
    mapit:             { include nginx::config::mapit }
    ertp_preview:      { include nginx::config::ertp::preview }
    ertp_api_staging:  { include nginx::config::ertp::api::staging }
    ertp_api_preview:  { include nginx::config::ertp::api::preview }
    ertp_staging:      { include nginx::config::ertp::staging }
    mirror:            { include nginx::config::mirror_server }
    UNSET:             {}
    default: {
      notify { '$node_type':
        message => "Unrecognised node type: $node_type"
      }
    }
  }
}

class nginx::config::redirect {
  nginx::config::vhost::redirect {
    'gov.uk':
      to => 'https://www.gov.uk/';
        'blog.alpha.gov.uk':
      to => 'http://digital.cabinetoffice.gov.uk/';
        'alpha.gov.uk':
      to => 'http://webarchive.nationalarchives.gov.uk/20111004104716/http://alpha.gov.uk/';
  }
}

class nginx::config::mirror_server {
  nginx::config::vhost::mirror {
    'www.gov.uk': ssl_only => true
      ;
    "www.$::govuk_platform.alphagov.co.uk":
      ;
  }
}

class nginx::config::mapit {
  file { '/etc/nginx/sites-enabled/mapit':
    ensure  => file,
    source  => 'puppet:///modules/mapit/nginx_mapit.conf'
  }
}
