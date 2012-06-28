class govuk_base {
  include ntp
  include apt
  include base_packages::unix_tools
  include sudo
  include logrotate
  include motd
  include wget
  include sysctl
  include users
  include cron
  include puppet
  class { 'ruby::rubygems':
    version => '1.8.24'
  }
  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=='
  }

  include nagios::client
  include ganglia::client
  include users::freerange
  include users::newbamboo
  include users::other
  include hosts
}

class govuk_base::redirect_server inherits govuk_base {
  class { 'nginx' : node_type => redirect }
  include nagios::client::checks
}

class govuk_base::db_server inherits govuk_base {
  include nagios::client::checks
}

class govuk_base::mongo_server inherits govuk_base {
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

class govuk_base::ruby_app_server inherits govuk_base {
  include mysql::client
  include nagios::client::checks
  include nodejs

  package {
    'bundler':             ensure => installed, provider => gem;
    'rails':               ensure => '3.1.1',   provider => gem;
    'mysql2':              ensure => installed, provider => gem, require => Package['libmysqlclient-dev'];
    'rake':                ensure => '0.9.2',   provider => gem;
    'rack':                ensure => '1.3.5',   provider => gem;
    'dictionaries-common': ensure => installed;
    'wbritish-small':      ensure => installed;
    'miscfiles':           ensure => installed;
  }
}

class govuk_base::ruby_app_server::backend_server inherits govuk_base::ruby_app_server {
  class { 'apache2':
    port => '8080'
  }

  include passenger
  class { 'nginx' : node_type => backend_server }

  package { 'graphviz':
    ensure => installed
  }

  apache2::vhost::passenger {
    "needotron.$::govuk_platform.alphagov.co.uk":;
    "signon.$::govuk_platform.alphagov.co.uk":;
    "publisher.$::govuk_platform.alphagov.co.uk":;
    "imminence.$::govuk_platform.alphagov.co.uk":;
    "panopticon.$::govuk_platform.alphagov.co.uk":;
    "contactotron.$::govuk_platform.alphagov.co.uk":;
    "migratorator.$::govuk_platform.alphagov.co.uk":;
    "tariff-api.$::govuk_platform.alphagov.co.uk":;
    "private-frontend.$::govuk_platform.alphagov.co.uk":;
  }

  file { "/etc/apache2/sites-enabled/signonotron.$::govuk_platform.alphagov.co.uk":
    ensure => absent,
    notify => Exec['apache_graceful']
  }

  file { "/etc/apache2/sites-available/signonotron.$::govuk_platform.alphagov.co.uk":
    ensure => absent,
    notify => Exec['apache_graceful']
  }

  file { "/data/vhost/signonotron.$::govuk_platform.alphagov.co.uk":
    ensure => absent,
    force  => true,
  }
}

class govuk_base::ruby_app_server::frontend_server inherits govuk_base::ruby_app_server {
  class { 'apache2':
    port => '8080'
  }
  include passenger
  class { 'nginx' : node_type => frontend_server }

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
    "licencefinder.$::govuk_platform.alphagov.co.uk":
      additional_port => 8086;
    "tariff.$::govuk_platform.alphagov.co.uk":
      additional_port => 8087;
    "efg.$::govuk_platform.alphagov.co.uk":
      additional_port => 8088;
    "static.$::govuk_platform.alphagov.co.uk":;
  }

  file { "/data/vhost/frontend.$::govuk_platform.alphagov.co.uk":
    ensure => link,
    target => "/data/vhost/www.$::govuk_platform.alphagov.co.uk",
    owner  => 'deploy',
    group  => 'deploy',
  }

}

class govuk_base::ruby_app_server::whitehall_frontend_server inherits govuk_base::ruby_app_server {
  class {'apache2':
    port => '8080'
  }
  include passenger
  class { 'nginx' : node_type => whitehall_frontend_server }
  include imagemagick

  apache2::vhost::passenger {
    "whitehall.$::govuk_platform.alphagov.co.uk":
      aliases => ["whitehall-frontend.$::govuk_platform.alphagov.co.uk"];
    "whitehall-search.$::govuk_platform.alphagov.co.uk":;
  }

}

class govuk_base::cache_server inherits govuk_base {
  include nagios::client::checks
  class { 'varnish': storage_size => '6G', default_ttl => 900 }

  include router
  include jetty

  class { 'nginx' : node_type => router}

  package { 'apache2':
    ensure => absent,
  }
}

class govuk_base::support_server inherits govuk_base {
  include nagios::client::checks
  include solr
  include apollo
  if $::govuk_platform == 'production' {
    /*
      Since these backups are only for the purposes of restoring production
      data to preview and development, it makes no sense to configure them on
      any environment but production
    */
    include mysql::backup
  }
  class {'elasticsearch':
    cluster => $::govuk_platform
  }
}

class govuk_base::monitoring_server inherits govuk_base {
  include nagios
  # include ganglia
}

class govuk_base::graylog_server inherits govuk_base {
  include nagios::client::checks
  include mongodb::server
}

class govuk_base::management_server {
  $mysql_password = extlookup('mysql_root', '')
  include govuk_base::ruby_app_server
  include govuk::testing_tools
  class { 'mysql::server':
    root_password => $mysql_password
  }
  include mongodb::server
  class {'mongodb::configure_replica_set':
    members => ['localhost:27081, localhost:27019, localhost:2720']
  }
  include solr
  include jenkins
  include imagemagick
  class {'elasticsearch':
    cluster => $::govuk_platform
  }

  mysql::server::db {
    'whitehall_development':
      user          => 'whitehall',
      password      => 'whitehall',
      host          => 'localhost',
      root_password => $mysql_password;
    'whitehall_test':
      user          => 'whitehall',
      password      => 'whitehall',
      host          => 'localhost',
      root_password => $mysql_password;
    'contactotron_test':
      user          => 'contactotron',
      password      => 'contactotron',
      host          => 'localhost',
      root_password => $mysql_password;
    'panopticon_test':
      user          => 'panopticon',
      password      => 'panopticon',
      host          => 'localhost',
      root_password => $mysql_password;
    'signonotron2_test':
      user          => 'signonotron2',
      password      => 'signonotron2',
      host          => 'localhost',
      root_password => $mysql_password;
    'signonotron2_integration_test':
      user          => 'signonotron2',
      password      => 'signonotron2',
      host          => 'localhost',
      root_password => $mysql_password;
    'efg_test':
      user          => 'efg',
      password      => 'efg',
      host          => 'localhost',
      root_password => $mysql_password;
  }
}

class govuk_base::puppetmaster inherits govuk_base {
  include puppet::master
  include nagios::client::checks
}
