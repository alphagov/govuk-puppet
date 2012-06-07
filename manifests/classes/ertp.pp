class ertp_base {
  include ntp
  include apt
  include base_packages::unix_tools
  include sudo
  include logrotate
  include motd
  include wget
  include sysctl
  include users
  include users::ertp
  include hosts::ertp
}

class ertp_base::mongo_server inherits ertp_base {
  include mongodb::server

  case $::govuk_platform {
    staging: {
      class {'mongodb::configure_replica_set':
        members => [
          'ertp-mongo-1',
          'ertp-mongo-2',
          'ertp-mongo-3'
        ]
      }
    }
    default: {
    }
  }
}

class ertp_base::frontend_server inherits ertp_base {
  class { 'jetty':
    version => '7.5.4.v20111024'
  }
  include nginx::ertp
  include ertp::config
  include ertp::scripts
}

class ertp_base::api_server inherits ertp_base {
  class { 'jetty':
    version => '7.5.4.v20111024'
  }
}

class ertp_base::api_server::dwp inherits ertp_base::api_server {
  include ertp::config
  include places::scripts
  include ertp-api::scripts
}

class ertp_base::api_server::ero inherits ertp_base::api_server {
  include ertp::config
  include places::scripts
  include ertp-api::scripts
}

class ertp_base::api_server::citizen inherits ertp_base::api_server {
  include ertp::config
  include places::scripts
  include ertp-api::scripts
}

class ertp_base::api_server::all inherits ertp_base::api_server {
  include ertp::config
  include places::scripts
  include ertp-api::scripts
}

class ertp_base::development inherits ertp_base {
  include ertp_base::mongo_server
  class { 'jetty':
    version => '7.5.4.v20111024'
  }
  include ertp::config
  include nginx::ertp
  include ertp::config
  include ertp::scripts
}
