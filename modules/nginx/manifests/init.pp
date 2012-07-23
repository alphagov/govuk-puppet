class nginx($node_type = 'development') {
  include logster
  include graylogtail
  include logstash::client

  include nginx::package
  class { 'nginx::config' : node_type => $node_type }
  include nginx::service
}

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

  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Exec['nginx_reload'],
  }
  file { '/etc/nginx/blockips.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/blockips.conf',
    require => Package['nginx'],
    notify  => Exec['nginx_reload'],
  }

  file { '/etc/nginx/conf.d/nginx-status.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx-status.conf',
    require => Package['nginx'],
    notify  => Exec['nginx_reload'],
  }
  file { '/usr/local/bin/nginx_ganglia2.sh':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx_ganglia2.sh',
    mode    => '0755',
    require => Package['nginx'],
    notify  => Exec['nginx_reload'],
  }
  cron { 'ganglia-nginx-status':
    command => '/usr/local/bin/nginx_ganglia2.sh',
    user    => root,
    minute  => '*/2',
    require => [ File['/usr/local/bin/nginx_ganglia2.sh'], File['/etc/nginx/conf.d/nginx-status.conf'] ]
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
    mode    => '0777',
    require => File['/usr/share/nginx'],
  }
  file { '/etc/nginx/htpasswd':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['nginx']
  }
  file { '/etc/nginx/ssl':
    ensure  => directory,
    require => Package['nginx'],
  }
  file { '/etc/logstash/logstash-client/nginx.conf':
    source  => 'puppet:///modules/nginx/etc/logstash/logstash-client/nginx.conf',
    require => Class['logstash::client::service']
  }
  case $node_type {
    router : {
      @@nagios::check { "check_nginx_active_connections_${::hostname}":
        use                 => 'generic-service',
        check_command       => 'check_ganglia_metric!nginx_active_connections!1000!2000',
        service_description => 'check nginx active connections',
        host_name           => "${::govuk_class}-${::hostname}",
      }
    }
    default : {
      @@nagios::check { "check_nginx_active_connections_${::hostname}":
        use                 => 'generic-service',
        check_command       => 'check_ganglia_metric!nginx_active_connections!500!1000',
        service_description => 'check nginx active connections',
        host_name           => "${::govuk_class}-${::hostname}",
      }
    }
  }

  case $node_type  {
    redirect: { include nginx::config::redirect }
    frontend_server: { include nginx::config::frontend_server }
    backend_server: { include nginx::config::backend_server }
    whitehall_frontend_server: { include nginx::config::whitehall_frontend_server }
    elms : {  include nginx::config::elms }
    development : { include nginx::config::development }
    router : { include nginx::config::router }
    mapit : { include nginx::config::mapit }
    ertp_preview : { include nginx::config::ertp::preview }
    ertp_api_staging : { include nginx::config::ertp::api::staging }
    ertp_api_preview : { include nginx::config::ertp::api::preview }
    ertp_staging : { include nginx::config::ertp::staging }
    mirror : { include nginx::config::mirror_server }
    default : {
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
  file { "/etc/nginx/sites-enabled/signonotron.$::govuk_platform.alphagov.co.uk":
    ensure => absent,
    notify => Exec['nginx_reload']
  }

  file { "/etc/nginx/sites-available/signonotron.$::govuk_platform.alphagov.co.uk":
    ensure => absent,
    notify => Exec['nginx_reload']
  }
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
      ssl_only  => true;
    "explore-reviewomatic.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:3023'],
      protected => false,
      ssl_only  => true;
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
    source  => 'puppet:///modules/mapit/nginx_mapit.conf',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }
}
