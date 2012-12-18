class govuk::node::router_mongo inherits govuk::node::base {
  # this is a newly defined node, so they will not be present on aws
  include mongodb::server

  case $::govuk_provider {
    sky: {
      case $::govuk_platform {
        'production', 'staging': {
          $mongo_hosts = [
            'router-1.mongo',
            'router-2.mongo',
            'router-3.mongo'
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
