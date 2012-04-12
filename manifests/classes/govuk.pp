class base {
  include ntp
  include apt
  include base_packages::unix_tools
  include sudo
  include logrotate
  include motd
  include wget
  include sysctl
  include users
  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=='
  }
}

class govuk_base inherits base {
  include nagios::client
  include ganglia::client
  include users::freerange
  include users::other
  include hosts
}

class redirect_server inherits govuk_base {
  include nginx
  include nagios::client::checks

  nginx::vhost::redirect {
    'gov.uk':
      to => 'https://www.gov.uk/';
    'blog.alpha.gov.uk':
      to => 'http://digital.cabinetoffice.gov.uk/';
    'alpha.gov.uk':
      to => 'http://webarchive.nationalarchives.gov.uk/20111004104716/http://alpha.gov.uk/';
  }
}

class db_server inherits govuk_base {
  include nagios::client::checks
}

class mongo_server inherits govuk_base {
  include mongodb::server

  case $::govuk_platform {
    production: {
      $mongo_hosts = [
        'production-mongo-client-20111213170552-01-internal.hosts.alphagov.co.uk',
        'production-mongo-client-20111213170334-01-internal.hosts.alphagov.co.uk',
        'production-mongo-client-20111213170556-01-internal.hosts.alphagov.co.uk'
      ]
    }
    preview: {
      $mongo_hosts = [
        'preview-mongo-client-20111213143425-01-internal.hosts.alphagov.co.uk',
        'preview-mongo-client-20111213125804-01-internal.hosts.alphagov.co.uk',
        'preview-mongo-client-20111213124811-01-internal.hosts.alphagov.co.uk'
      ]
    }
    default: {
      $mongo_hosts = ['localhost']
    }
  }

  if ($mongo_hosts) {
    class {'mongodb::configure_replica_set':
      members => $mongo_hosts
    }
    class {'mongodb::backup':
      members => $mongo_hosts
    }
  }

  include nagios::client::checks
}

class ruby_app_server inherits govuk_base {
  include mysql::client
  include nagios::client::checks

  package {
    'bundler':             ensure => installed, provider => gem;
    'rails':               ensure => '3.1.1',   provider => gem;
    'mysql2':              ensure => installed, provider => gem, require => Package['libmysqlclient-dev'];
    'rake':                ensure => '0.9.2',   provider => gem;
    'rack':                ensure => '1.3.5',   provider => gem;
    'dictionaries-common': ensure => installed;
    'miscfiles':           ensure => installed;
  }
}

class backend_server inherits ruby_app_server {
  $apache_port = '8080'
  include apache2
  include passenger
  include nginx

  package { 'graphviz':
    ensure => installed
  }

  apache2::vhost::passenger {
    "needotron.$::govuk_platform.alphagov.co.uk":;
    "signonotron.$::govuk_platform.alphagov.co.uk":;
    "signon.$::govuk_platform.alphagov.co.uk":;
    "publisher.$::govuk_platform.alphagov.co.uk":;
    "imminence.$::govuk_platform.alphagov.co.uk":;
    "panopticon.$::govuk_platform.alphagov.co.uk":;
    "contactotron.$::govuk_platform.alphagov.co.uk":;
    "private-frontend.$::govuk_platform.alphagov.co.uk":;
  }

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
    "signonotron.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      protected => false,
      ssl_only  => true;
    "panopticon.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "signon.$::govuk_platform.alphagov.co.uk":
      to        => ['localhost:8080'],
      protected => false,
      ssl_only  => true;
    "panopticon.$govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "contactotron.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
    "private-frontend.$::govuk_platform.alphagov.co.uk":
      to       => ['localhost:8080'],
      ssl_only => true;
  }
}

class frontend_server inherits ruby_app_server {
  $apache_port = '8080'
  include apache2
  include passenger
  include nginx

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
  }

  apache2::vhost::passenger {
    "www.$::govuk_platform.alphagov.co.uk":
      aliases       => ["frontend.$::govuk_platform.alphagov.co.uk", 'www.gov.uk'];
    "planner.$::govuk_platform.alphagov.co.uk":
      additional_port => 8081;
    "calendars.$::govuk_platform.alphagov.co.uk":
      additional_port => 8082;
    "search.$::govuk_platform.alphagov.co.uk":
      additional_port => 8083;
    "smartanswers.$::govuk_platform.alphagov.co.uk":
      additional_port => 8084;
    "designprinciples.$::govuk_platform.alphagov.co.uk":
      additional_port => 8085;
    "static.$::govuk_platform.alphagov.co.uk":;
  }

  file { "/data/vhost/frontend.$::govuk_platform.alphagov.co.uk":
    ensure => link,
    target => "/data/vhost/www.$::govuk_platform.alphagov.co.uk",
    owner  => 'deploy',
    group  => 'deploy',
  }

  nginx::vhost::static { "static.$::govuk_platform.alphagov.co.uk":
    protected => false,
    aliases   => ['calendars', 'planner', 'smartanswers', 'static', 'frontend', 'designprinciples'],
    ssl_only  => true
  }
}

class whitehall_frontend_server inherits ruby_app_server {
  $apache_port = '8080'
  include apache2
  include passenger
  include nginx
  include imagemagick

  apache2::vhost::passenger {
    "whitehall.$::govuk_platform.alphagov.co.uk":
      additional_port => '8085';
    "whitehall-search.$::govuk_platform.alphagov.co.uk":;
  }

  nginx::vhost::proxy {
    "whitehall.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
    "whitehall-search.$::govuk_platform.alphagov.co.uk":
      to => ['localhost:8080'];
  }

  if $::govuk_platform == 'preview' {
    file { '/etc/nginx/sites-available/whitehall.staging.alphagov.co.uk':
      ensure  => file,
      content => "server {
          server_name whitehall.staging.alphagov.co.uk;
          rewrite ^(.*)\$ http://whitehall.preview.alphagov.co.uk\$1 permanent;
      }",
      require => Package['nginx'],
    }

    nginx::nxensite { 'whitehall.staging.alphagov.co.uk': }
  }
}

class cache_server inherits govuk_base {
  include nagios::client::checks
  include varnish

  include router
  include nginx::router

  package { 'apache2':
    ensure => absent,
  }
}

class support_server inherits govuk_base {
  include nagios::client::checks
  include solr
  include apollo
  include mysql::backup
}

class monitoring_server inherits govuk_base {
  include nagios
  include ganglia
}

class graylog_server inherits govuk_base {
  include nagios::client::checks
  include mongodb::server
}

class management_server {
  $mysql_password = extlookup('mysql_root')
  $apache_port = '80'
  include ruby_app_server
  include govuk::testing_tools
  include mysql::server
  include mongodb::server
  class {'mongodb::configure_replica_set':
    members => ['localhost:27081, localhost:27019, localhost:2720']
  }
  include solr
  include jenkins
  include rundeck
  include imagemagick

  mysql::server::db {
    'whitehall_development':
      user     => 'whitehall',
      password => 'whitehall',
      host     => 'localhost';
    'whitehall_test':
      user     => 'whitehall',
      password => 'whitehall',
      host     => 'localhost';
    'contactotron_test':
      user     => 'contactotron',
      password => 'contactotron',
      host     => 'localhost';
    'panopticon_test':
      user     => 'panopticon',
      password => 'panopticon',
      host     => 'localhost';
    'signonotron2_test':
      user     => 'signonotron2',
      password => 'signonotron2',
      host     => 'localhost';
  }
}

class puppetmaster inherits govuk_base {
  include puppetrundeck
  include webpuppet
}
