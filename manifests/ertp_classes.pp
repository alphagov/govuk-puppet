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
}

# ERTP MongoServer Configuration
class ertp_mongo_server inherits ertp_base {
  include mongodb::server
  class {'mongodb::configure_replica_set':
    members => ['localhost']
  }
}

# ERTP Front End Server Configuration
class ertp_frontend_server inherits ertp_base {
  $jetty_version = "7.5.4.v20111024"
  include jetty
  include nginx::ertp
}

# ERTP API Server Configuration
class ertp_api_server inherits ertp_base {
  $jetty_version = "7.5.4.v20111024"
  include jetty
}

# ERTP Development Configuration
class ertp_development inherits ertp_base {
  include ertp_mongo_server
  include ertp_api_server
  include ertp_frontend_server
}
