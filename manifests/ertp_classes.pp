class ertp_base {
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
  include jetty
  include nginx
}

# ERTP API Server Configuration
class ertp_api_server inherits ertp_base {
  include jetty
}

# ERTP Development Configuration
class ertp_development inherits ertp_base {
  include ertp_mongo_server
  include ertp_api_server
  include ertp_frontend_server
}