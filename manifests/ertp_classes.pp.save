class ertp_base {
}

class ertp_mongo_server inherits ertp_base {
  include mongodb::server
  class {'mongodb::configure_replica_set':
    members => ['localhost']
  }
}

class ertp_development inherits ertp_base {
  include ertp_mongo_server
}
