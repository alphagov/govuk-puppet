class places_base {
  include ntp
  include apt
  include base_packages::unix_tools
  include sudo
  include logrotate
  include motd
  include wget
  include sysctl
  include users
  include users::setup
  include hosts::places
}

class places_base::mongo_server inherits places_base {
  include mongodb::server

  case $::govuk_platform {
    staging: {
      class {'mongodb::configure_replica_set':
        members => [
          'places-mongo-1',
          'places-mongo-2',
          'places-mongo-3'
        ]
      }
    }
    default: {
    }
  }
}

class places_base::api_server inherits places_base {
  include places::scripts
}