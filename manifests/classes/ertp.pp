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

# ERTP MongoServer Configuration
class ertp_base::mongo_server inherits ertp_base {
  include mongodb::server
}

# ERTP Front End Server Configuration
class ertp_base::frontend_server inherits ertp_base {
  class { 'jetty':
    version => '7.5.4.v20111024'
  }
  include nginx::ertp
  include ertp::config
  include ertp::scripts
}

# ERTP API Server Configuration
class ertp_base::api_server inherits ertp_base {
  class { 'jetty':
    version => '7.5.4.v20111024'
  }
  include ertp::config
}

# ERTP Development Configuration
class ertp_base::development inherits ertp_base {
  include ertp_base::mongo_server
  include ertp_base::api_server
  include ertp_base::frontend_server
  include ertp::config
}
