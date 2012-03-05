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
    type => 'ssh-rsa',
    key => extlookup("github_key")
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
    "gov.uk":
      to => "https://www.gov.uk/";
    "blog.alpha.gov.uk":
      to => "http://digital.cabinetoffice.gov.uk/";
    "alpha.gov.uk":
      to => "http://webarchive.nationalarchives.gov.uk/20111004104716/http://alpha.gov.uk/";
  }
}

class db_server inherits govuk_base {
  include nagios::client::checks
}

class mongo_server inherits govuk_base {
  include mongodb::server

  case $govuk_platform {
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
    "bundler": provider => gem, ensure => installed;
    "rails":   provider => gem, ensure => "3.1.1";
    "mysql2":  provider => gem, ensure => installed, require => Package["libmysqlclient-dev"];
    "rake":    provider => gem, ensure => "0.9.2";
    "rack":    provider => gem, ensure => "1.3.5",
  }

  package {
    'dictionaries-common': ensure => installed;
    'miscfiles': ensure => installed;
  }
}

class backend_server inherits ruby_app_server {
  $apache_port = 8080
  include apache2
  include passenger
  include nginx

  package { 'graphviz':
    ensure => installed
  }

  apache2::vhost::passenger {
    "needotron.$govuk_platform.alphagov.co.uk":;
    "signonotron.$govuk_platform.alphagov.co.uk":;
    "publisher.$govuk_platform.alphagov.co.uk":;
    "imminence.$govuk_platform.alphagov.co.uk":;
    "panopticon.$govuk_platform.alphagov.co.uk":;
    "contactotron.$govuk_platform.alphagov.co.uk":;
    "private-frontend.$govuk_platform.alphagov.co.uk":;
  }

  nginx::vhost::proxy {
    "imminence.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"],
      ssl_only => true;
    "publisher.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"],
      ssl_only => true;
    "needotron.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"],
      ssl_only => true;
    "signonotron.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"],
      protected => false,
      ssl_only => true;
    "panopticon.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"],
      ssl_only => true;
    "contactotron.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"],
      ssl_only => true;
    "private-frontend.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"],
      ssl_only => true;
  }
}

class frontend_server inherits ruby_app_server {
  $apache_port = 8080
  include apache2
  include passenger
  include nginx

  nginx::vhost::proxy {
    "www.gov.uk":
      to      => ["localhost:8080"];
    "www.$govuk_platform.alphagov.co.uk":
      to      => ["localhost:8080"],
      aliases => ["frontend.$govuk_platform.alphagov.co.uk"];
    "planner.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"];
    "calendars.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"];
    "search.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"];
    "smartanswers.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"];
  }

  apache2::vhost::passenger {
    "www.$govuk_platform.alphagov.co.uk":
      aliases       => ["frontend.$govuk_platform.alphagov.co.uk", "www.gov.uk"];
    "planner.$govuk_platform.alphagov.co.uk":
      additional_port => 8081;
    "calendars.$govuk_platform.alphagov.co.uk":
      additional_port => 8082;
    "search.$govuk_platform.alphagov.co.uk":
      additional_port => 8083;
    "smartanswers.$govuk_platform.alphagov.co.uk":
      additional_port => 8084;
    "static.$govuk_platform.alphagov.co.uk":;
  }

  file { "/data/vhost/frontend.$govuk_platform.alphagov.co.uk":
    ensure => link,
    target => "/data/vhost/www.$govuk_platform.alphagov.co.uk",
    owner  => 'deploy',
    group  => 'deploy',
  }

  nginx::vhost::static { "static.$govuk_platform.alphagov.co.uk":
    protected => false,
    aliases   => ["calendars", "planner", "smartanswers", "static", "frontend"],
    ssl_only  => true
  }
}

class whitehall_frontend_server inherits ruby_app_server {
  $apache_port = 8080
  include apache2
  include passenger
  include nginx
  include imagemagick

  apache2::vhost::passenger {
    "whitehall.$govuk_platform.alphagov.co.uk":
      additional_port => 8085;
    "whitehall-search.$govuk_platform.alphagov.co.uk":;
  }

  nginx::vhost::proxy {
    "whitehall.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"];
    "whitehall-search.$govuk_platform.alphagov.co.uk":
      to => ["localhost:8080"];
  }

  if $govuk_platform == 'preview' {
    file { '/etc/nginx/sites-available/whitehall.staging.alphagov.co.uk':
      ensure => file,
      content => "server {
          server_name whitehall.staging.alphagov.co.uk;
          rewrite ^(.*)\$ http://whitehall.preview.alphagov.co.uk\$1 permanent;
      }",
      require => Package['nginx'],
    }

    nginx::nxensite { "whitehall.staging.alphagov.co.uk": }
  }
}

class cache_server inherits govuk_base {
  include nagios::client::checks
  include varnish

  include router
  include nginx::router

  package { "apache2":
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
  $mysql_password = extlookup("mysql_root")
  $apache_port = 80
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
  }
}

class puppetmaster inherits govuk_base {
  include puppetrundeck
  include webpuppet
}

class development {
  include base_packages::unix_tools
  include govuk::testing_tools
  include nginx::development
  include mongodb::server
  include apollo
  include hosts
  include users
  include solr
  include apt

  $mysql_password = "alphagov"
  include mysql::server
  include mysql::client

  mysql::server::db {
    "fco_development":          user => "fco",          password => "",           host => "localhost";
    "needotron_development":    user => "needotron",    password => "",           host => "localhost";
    "panopticon_development":   user => "panopticon",   password => "panopticon", host => "localhost";
    "panopticon_test":          user => "panopticon",   password => "panopticon", host => "localhost";
    "contactotron_development": user => "contactotron", password => "",           host => "localhost";
  }

  package {
    "bundler":      provider => gem, ensure => "installed";
    "foreman":      provider => gem, ensure => "installed";
    "mysql2":       provider => gem, ensure => "installed";
    "ruby-debug19": provider => gem, ensure => "installed";
    "rails":        provider => gem, ensure => "installed";
    "passenger":    provider => gem, ensure => "installed";
    "apache2":                       ensure => "absent";
  }
}
