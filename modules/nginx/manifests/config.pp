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

  if $node_type != 'development' {
    file { '/usr/local/bin/nginx_ganglia2.sh':
      ensure  => file,
      source  => 'puppet:///modules/nginx/nginx_ganglia2.sh',
      mode    => '0755';
    }
    cron { 'ganglia-nginx-status':
      command => '/usr/local/bin/nginx_ganglia2.sh',
      user    => root,
      minute  => '*/2',
      require => [ File['/usr/local/bin/nginx_ganglia2.sh'], File['/etc/nginx'] ]
    }


    file { '/etc/logstash/logstash-client/nginx.conf':
      source  => 'puppet:///modules/nginx/etc/logstash/logstash-client/nginx.conf',
      notify  => Service['logstash-client']
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
  }

  case $node_type  {
    redirect:          { include nginx::config::redirect }
    frontend_server:   { include nginx::config::frontend_server }
    backend_server:    { include nginx::config::backend_server }
    whitehall_frontend_server: { include nginx::config::whitehall_frontend_server }
    elms:              { include nginx::config::elms }
    development:       { include nginx::config::development }
    router:            { include nginx::config::router }
    mapit:             { include nginx::config::mapit }
    ertp_preview:      { include nginx::config::ertp::preview }
    ertp_api_staging:  { include nginx::config::ertp::api::staging }
    ertp_api_preview:  { include nginx::config::ertp::api::preview }
    ertp_staging:      { include nginx::config::ertp::staging }
    mirror:            { include nginx::config::mirror_server }
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
    'www.gov.uk':
      ;
    "www.$::govuk_platform.alphagov.co.uk":
      ;
  }
}

class nginx::config::frontend_server {
  nginx::config::vhost::proxy {
    'www.gov.uk':
      to      => ['localhost:8080'];
    "www.$::govuk_platform.alphagov.co.uk":
      to      => ['localhost:8080'],
      aliases => ["frontend.$::govuk_platform.alphagov.co.uk"];
    "calendars.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "search.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "smartanswers.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "designprinciples.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "licencefinder.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "tariff.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "efg.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "contentapi.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
  }

  nginx::config::vhost::static { "static.$::govuk_platform.alphagov.co.uk":
    protected => false,
    aliases   => ['calendars', 'planner', 'smartanswers', 'static', 'frontend', 'designprinciples', 'licencefinder', 'tariff', 'efg'],
    ssl_only  => true
  }
}

class nginx::config::whitehall_frontend_server {
  nginx::config::vhost::proxy {
    "whitehall.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "whitehall-frontend.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'];
    "whitehall-search.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
  }
}

class nginx::config::backend_server {
  nginx::config::vhost::proxy {
    "imminence.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "publisher.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "needotron.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "panopticon.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "signon.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      protected => false,
      ssl_only  => true;
    "migratorator.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      ssl_only  => true;
    "reviewomatic.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      ssl_only  => false;
    "contactotron.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "tariff-api.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "private-frontend.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "whitehall-admin.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
  }
}

class nginx::config::mapit {
  file { '/etc/nginx/sites-enabled/mapit':
    ensure  => file,
    source  => 'puppet:///modules/mapit/nginx_mapit.conf'
  }
}
