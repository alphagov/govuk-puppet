class govuk_node::router_mongo inherits govuk_node::base {
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
