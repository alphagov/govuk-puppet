class places_base {
  include base
  include monitoring::client
  include java::sun6::jre
  include users
  include users::groups::govuk
  include hosts::places
  include govuk::deploy
}

class places_base::mongo_server inherits places_base {
  include mongodb::server
  include mongodb::monitoring

  class {'mongodb::configure_replica_set':
    members => [
      'places-mongo-1',
      'places-mongo-2',
      'places-mongo-3'
    ]
  }
}


class places_base::api_server inherits places_base {
  include places::scripts
  include places::config
}
