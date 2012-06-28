class nginx($node_type = 'development') {
  include logster
  include graylogtail

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
  include nginx::install
  include nginx::service
  class { 'nginx::config' : node_type => $node_type }
}

class nginx::config($node_type) {
  case $node_type  {
    redirect: { include nginx::config::redirect }
    proxy: { include nginx::config::proxy }
    frontend_server: { include nginx::config::frontend_server }
    backend_server: { include nginx::config::backend_server }
    whitehall_frontend_server: { include nginx::config::whitehall_frontend_server }
    default : {
      notify { '$node_type':
        message => "Unrecognised node type: $node_type"
      }
    }
  }
}

class nginx::config::redirect {
  nginx::vhost::redirect {
    'gov.uk':
      to => 'https://www.gov.uk/';
        'blog.alpha.gov.uk':
      to => 'http://digital.cabinetoffice.gov.uk/';
        'alpha.gov.uk':
      to => 'http://webarchive.nationalarchives.gov.uk/20111004104716/http://alpha.gov.uk/';
  }
}

class nginx::config::proxy {
  nginx::vhost::proxy {
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
    "contactotron.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "tariff-api.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "private-frontend.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
  }
}

class nginx::config::frontend_server {
  nginx::vhost::proxy {
    'www.gov.uk':
      to      => ['localhost:8080'];
    "www.$::govuk_platform.alphagov.co.uk":
      to      => ['localhost:8080'],
      aliases => ["frontend.$::govuk_platform.alphagov.co.uk"];
    "planner.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
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
  }
  nginx::vhost::static { "static.$::govuk_platform.alphagov.co.uk":
    protected => false,
    aliases   => ['calendars', 'planner', 'smartanswers', 'static', 'frontend', 'designprinciples', 'licencefinder', 'tariff', 'efg'],
    ssl_only  => true
  }
}

class nginx::config::whitehall_frontend_server {
  nginx::vhost::proxy {
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
}
