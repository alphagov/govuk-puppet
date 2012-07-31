class govuk_base {
  include base

  include ganglia::client
  include graphite::client
  include hosts
  include nagios::client
  include puppet
  include puppet::cronjob
  include users
  include users::groups::freerange
  include users::groups::govuk
  include users::groups::newbamboo
  include users::groups::other

  include govuk::repository
  include govuk::deploy_tools
  include logstash::client

  class { 'ruby::rubygems':
    version => '1.8.24'
  }

  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=='
  }

}

class govuk_base::redirect_server inherits govuk_base {
  class { 'nginx' : node_type => redirect }
  include nagios::client::checks
}

class govuk_base::db_server inherits govuk_base {
  include nagios::client::checks
}

class govuk_base::mysql_master_server inherits govuk_base{
  #currently mysql  is just turned on for preview, this condition will be removed when everybody moves out of RDS
  if ($::govuk_platform == 'preview') {
    $root_password = extlookup('mysql_root', '')
    $master_server_id = '1'
    class { 'mysql::server':
      root_password => $root_password,
      server_id     => $master_server_id
    }

    class { 'mysql::server::monitoring':
      root_password => $root_password
    }

    include govuk::apps::need_o_tron::db
  }
}

class govuk_base::mysql_slave_server inherits govuk_base{
  #currently mysql  is just turned on for preview, this condition will be removed when everybody moves out of RDS
  if ($::govuk_platform == 'preview') {
    $root_password = extlookup('mysql_root', '')
    class { 'mysql::server':
      root_password => $root_password,
      server_id     => $::slave_server_id,
      config_path   => 'mysql/slave/my.cnf'
    }

    class { 'mysql::server::monitoring':
      root_password => $root_password
    }

    include govuk::apps::need_o_tron::db
  }
}

class govuk_base::mongo_server inherits govuk_base {
  include mongodb::server
  include mongodb::monitoring

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
  include bundler

  package {
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
    port => '8080',
  }
  class { 'passenger':
    maxpoolsize => 12,
  }
  class { 'nginx':
    node_type => backend_server,
  }
  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  apache2::vhost::passenger {
    "needotron.$::govuk_platform.alphagov.co.uk":;
    "signon.$::govuk_platform.alphagov.co.uk":;
    "publisher.$::govuk_platform.alphagov.co.uk":;
    "imminence.$::govuk_platform.alphagov.co.uk":;
    "panopticon.$::govuk_platform.alphagov.co.uk":;
    "contactotron.$::govuk_platform.alphagov.co.uk":;
    "migratorator.$::govuk_platform.alphagov.co.uk":;
    "reviewomatic.$::govuk_platform.alphagov.co.uk":;
    "tariff-api.$::govuk_platform.alphagov.co.uk":;
    "private-frontend.$::govuk_platform.alphagov.co.uk":;
  }

  file { "/data/vhost/signonotron.$::govuk_platform.alphagov.co.uk":
    ensure => absent,
    force  => true,
  }

  include govuk::apps::review_o_matic_explore
  include govuk::apps::whitehall_admin
}

class govuk_base::ruby_app_server::frontend_server inherits govuk_base::ruby_app_server {
  class { 'apache2':
    port => '8080'
  }
  class { 'passenger' : maxpoolsize => 12 }

  include govuk::apps::planner

  class { 'nginx' : node_type       => frontend_server }

  apache2::vhost::passenger {
    "www.$::govuk_platform.alphagov.co.uk":
      aliases       => ["frontend.$::govuk_platform.alphagov.co.uk", 'www.gov.uk'];
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
    "contentapi.$::govuk_platform.alphagov.co.uk":
      additional_port => 8089;
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
  include nginx

  nginx::config::vhost::redirect {
    "whitehall.$::govuk_platform.alphagov.co.uk":
      to => "https://whitehall-frontend.$::govuk_platform.alphagov.co.uk/";
  }

  include govuk::apps::whitehall_frontend
  include govuk::apps::whitehall_search
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
  class { 'apache2': port => '80'}
  include nagios
  include nagios::client::checks
  include ganglia
  include graphite
}

class govuk_base::graylog_server inherits govuk_base {
  include nagios::client::checks
  include mongodb::server
  include mongodb::monitoring
  include logstash::server
}

class govuk_base::management_server {
  include apt
  $mysql_password = extlookup('mysql_root', '')

  include govuk_base::ruby_app_server

  include govuk::deploy_tools
  include govuk::testing_tools

  include nodejs

  class { 'mysql::server':
    root_password => $mysql_password
  }
  class { 'mysql::server::monitoring':
    root_password => $mysql_password
  }

  include mongodb::server
  include mongodb::monitoring
  class {'mongodb::configure_replica_set':
    members => ['localhost']
  }

  include solr
  include imagemagick
  class {'elasticsearch':
    cluster => $::govuk_platform
  }

  mysql::server::db {
    'whitehall_development':
      user          => 'whitehall',
      password      => 'whitehall',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'whitehall_test':
      user          => 'whitehall',
      password      => 'whitehall',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'contactotron_test':
      user          => 'contactotron',
      password      => 'contactotron',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'panopticon_test':
      user          => 'panopticon',
      password      => 'panopticon',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'signonotron2_test':
      user          => 'signonotron2',
      password      => 'signonotron2',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'signonotron2_integration_test':
      user          => 'signonotron2',
      password      => 'signonotron2',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'efg_test':
      user          => 'efg',
      password      => 'efg',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
    'tariff_test':
      user          => 'tariff',
      password      => 'tariff',
      host          => 'localhost',
      remote_host   => 'localhost',
      root_password => $mysql_password;
  }
}

class govuk_base::management_server::master inherits govuk_base::management_server {
  include jenkins::master
}

class govuk_base::management_server::slave inherits govuk_base::management_server {
  include jenkins::slave

  ssh_authorized_key { 'management_server_master':
    type => rsa,
    key  => extlookup('jenkins_key', ''),
    user => 'jenkins'
  }
}

class govuk_base::puppetmaster inherits govuk_base {
  include puppet::master
  include puppetdb
  include nagios::client::checks
}
