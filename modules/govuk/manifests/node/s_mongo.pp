class govuk::node::s_mongo inherits govuk::node::s_base {
  include mongodb::server
  #TODO: When Preview is no longer in EC2, the Mongo Servers
  #should not include the s_mysql_master class
  include govuk::node::s_mysql_master

  case $::govuk_provider {
    sky: {
      $mongo_hosts = [
        'backend-1.mongo',
        'backend-2.mongo',
        'backend-3.mongo'
      ]
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
