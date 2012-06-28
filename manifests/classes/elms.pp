class elms_base {
  include ntp
  include apt
  include base_packages::unix_tools
  include sudo
  include logrotate
  include motd
  include wget
  include sysctl
  include users
  include hosts::elms-preview
  include openjdk
}

class elms_base::mongo_server inherits elms_base {
  include mongodb::server

  class {'mongodb::configure_replica_set':
    members => [
      'elms-mongo-1',
      'elms-mongo-2',
      'elms-mongo-3'
    ]
  }
}

class elms_base::frontend_server inherits elms_base {
  include nginx::elms
  include elms::config
  include elms::scripts
}

class elms_base::development inherits elms_base {
  include elms_base::mongo_server
  include elms::config
  class { 'nginx' : node_type => elms }
  include elms::config
  include elms::scripts
}
