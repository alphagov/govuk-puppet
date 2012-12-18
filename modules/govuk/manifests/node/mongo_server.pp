class govuk::node::mongo_server inherits govuk::node::base {
  include mongodb::server

  case $::govuk_provider {
    sky: {
      case $::govuk_platform {
        'production', 'staging': {
          $mongo_hosts = [
            'backend-1.mongo',
            'backend-2.mongo',
            'backend-3.mongo'
          ]
        }
        default: {
          $mongo_hosts = ['localhost']
        }
      }
    }
    #aws
    default: {
      case $::govuk_platform {
        production: {
          $mongo_hosts = [
            'production-mongo-client-20111213170552-01-internal.hosts.alphagov.co.uk',
            'production-mongo-client-20111213170334-01-internal.hosts.alphagov.co.uk',
            'production-mongo-client-20111213170556-01-internal.hosts.alphagov.co.uk'
          ]
        }
        preview: {
          $mongo_hosts = [
            'preview-mongo-client-20111213143425-01-internal.hosts.alphagov.co.uk',
            'preview-mongo-client-20111213125804-01-internal.hosts.alphagov.co.uk',
            'preview-mongo-client-20111213124811-01-internal.hosts.alphagov.co.uk'
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
