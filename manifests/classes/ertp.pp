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
class ertp_mongo_server inherits ertp_base {
  include mongodb::server
}

# ERTP Front End Server Configuration
class ertp_frontend_server inherits ertp_base {
  $jetty_version = '7.5.4.v20111024'
  include jetty
  include nginx::ertp
  include ertp::config
  include ertp::scripts
}

# ERTP API Server Configuration
class ertp_api_server inherits ertp_base {
  $jetty_version = '7.5.4.v20111024'
  include jetty
  include ertp::config
  include places::scripts
}

# ERTP Development Configuration
class ertp_development inherits ertp_base {
  include ertp_mongo_server
  include ertp_api_server
  include ertp_frontend_server
  include ertp::config
}
