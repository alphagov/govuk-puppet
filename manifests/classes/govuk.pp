class govuk_base {
  include base
  include hosts
  include monitoring
  include puppet
  include puppet::cronjob
  include users
  include users::groups::freerange
  include users::groups::govuk
  include users::groups::newbamboo
  include users::groups::other

  include govuk::repository
  include govuk::deploy

  class { 'ruby::rubygems':
    version => '1.8.24'
  }

  sshkey { 'github.com':
    ensure => present,
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=='
  }

}

# This is not the redirector app, it handles redirects from alphagov to GOV.UK
class govuk_base::redirect_server inherits govuk_base {
  class { 'nginx': node_type => redirect }
}

# This is the redirector app for redirecting Directgov and Business Link URLs
class govuk_base::redirector_server inherits govuk_base {
  include nginx
  include govuk::apps::redirector
}

class govuk_base::db_server inherits govuk_base {
}

class govuk_base::mysql_master_server inherits govuk_base{
  $root_password = extlookup('mysql_root', '')
  $master_server_id = '1'

  class { 'mysql::server':
    root_password => $root_password,
    server_id     => $master_server_id
  }

  Class['mysql::server'] -> Class['govuk::apps::need_o_tron::db']

  include govuk::apps::signonotron::db
  include govuk::apps::need_o_tron::db
  include govuk::apps::tariff_api::db
}

class govuk_base::mysql_slave_server inherits govuk_base{
  $root_password = extlookup('mysql_root', '')

  class { 'mysql::server':
    root_password => $root_password,
    server_id     => $::slave_server_id,
    config_path   => 'mysql/slave/my.cnf'
  }

  include govuk::apps::need_o_tron::db
  include govuk::apps::tariff_api::db
}

class govuk_base::mongo_server inherits govuk_base {
  include mongodb::server

  case $::govuk_provider {
    sky: {
      case $::govuk_platform {
        production: {
          $mongo_hosts = [
            'mongo-1.production.internal',
            'mongo-2.production.internal',
            'mongo-3.production.internal'
          ]
        }
        default: {
          $mongo_hosts = ['localhost']
        }
      }
    }
    #aws
    default: {
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
    }
  }

  if ($mongo_hosts) {
    class { 'mongodb::configure_replica_set':
      members => $mongo_hosts
    }
    class { 'mongodb::backup':
      members => $mongo_hosts
    }
  }
}

class govuk_base::router_mongo inherits govuk_base {
  # this is a newly defined node, so they will not be present on aws
  include mongodb::server

  case $::govuk_provider {
    sky: {
      case $::govuk_platform {
        production: {
          $mongo_hosts = [
            '10.1.0.2',
            '10.1.0.7',
            '10.1.0.8'
          ]
        }
        default: {
          $mongo_hosts = ['localhost']
        }
      }
    }
  }

  if ($mongo_hosts) {
    class { 'mongodb::configure_replica_set':
      members => $mongo_hosts
    }
    class { 'mongodb::backup':
      members => $mongo_hosts
    }
  }
}

class govuk_base::ruby_app_server inherits govuk_base {
  include mysql::client
  include nodejs
  include bundler

  package {
    'rails':               ensure => '3.1.1',   provider => gem, require => Package['build-essential'];
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

  include govuk::apps::support

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
    "private-frontend.$::govuk_platform.alphagov.co.uk":;
  }

  file { "/data/vhost/signonotron.$::govuk_platform.alphagov.co.uk":
    ensure => absent,
    force  => true,
  }

  include govuk::apps::review_o_matic_explore
  include govuk::apps::tariff_api
  include govuk::apps::whitehall_admin
  if($::govuk_provider == 'sky') {
    include govuk::apps::need_o_tron
  }
}

class govuk_base::ruby_app_server::frontend_server inherits govuk_base::ruby_app_server {
  class { 'apache2':
    port => '8080'
  }
  class { 'passenger':
    maxpoolsize => 12
  }

  include govuk::apps::planner
  include govuk::apps::tariff
  include govuk::apps::efg

  class { 'nginx': node_type => frontend_server }

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
  class { 'varnish': storage_size => '6G', default_ttl => 900 }

  include router
  include jetty

  class { 'nginx': node_type => router}

  # Have realised that this purge does not kick in the first puppet run[Newly provisioned machines]
  # Needs to be fixed. Unsure of how apache sneaks in.
  # Kicks in the the next puppet run
  package { 'apache2':
    ensure => absent,
  }

  service { 'apache2':
    ensure => stopped
  }
}

class govuk_base::support_server inherits govuk_base {
  include solr
  include apollo

  if $::govuk_platform == 'production' {
    # Since these backups are only for the purposes of restoring production
    # data to preview and development, it makes no sense to configure them on
    # any environment but production.
    include mysql::backup
  }

  include elasticsearch
  elasticsearch::node { "govuk-${::govuk_platform}": }
}

class govuk_base::monitoring_server inherits govuk_base {
  class { 'apache2': port => '80'}
  include nagios
  include nagios::client
  include ganglia
  include graphite
}

class govuk_base::graylog_server inherits govuk_base {
  include elasticsearch
  include nagios::client
  include nginx
  include logstash::server

  nginx::config::vhost::proxy {
    "logging.$::govuk_platform.alphagov.co.uk":
      to      => ['localhost:9292'],
      aliases => ["graylog.$::govuk_platform.alphagov.co.uk"],
  }
}

class govuk_base::management_server {
  include apt
  include sshd

  include govuk_base::ruby_app_server

  include govuk::deploy
  include govuk::testing_tools

  include imagemagick
  include nodejs
  include solr

  include elasticsearch
  elasticsearch::node { "govuk-${::govuk_platform}": }

  include mongodb::server
  class { 'mongodb::configure_replica_set':
    members => ['localhost']
  }

  $mysql_password = extlookup('mysql_root', '')
  class { 'mysql::server':
    root_password => $mysql_password
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
    'datainsights_todays_activity_test':
      user          => 'datainsight',
      password      => 'datainsight',
      host          => 'localhost',
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
}


class govuk_base::mapit_server inherits govuk_base {
  include nginx
  include postgres::postgis
  include mapit

  postgres::user {'mapit':
      ensure   => present,
      password => 'mapit',
  }

  wget::fetch {'mapit_dbdump_download':
      source      => 'http://cdnt.samsharpe.net/mapit.sql.gz',
      destination => '/data/vhosts/mapit/data/mapit.sql.gz',
      require     => File['/data/vhosts/mapit/data/'],
  }
  postgres::database { 'mapit':
      ensure    => present,
      owner     => 'mapit',
      encoding  => 'UTF8',
      source    => '/data/vhosts/mapit/data/mapit.sql.gz',
      require   => [ Postgres::User['mapit'], Wget::Fetch['mapit_dbdump_download'] ],
  }
}
