class elms_base {
  include base
  include hosts
  include puppet
  include users
  include openjdk

  include govuk::repository
  include govuk::deploy
}

class elms_base::mongo_server inherits elms_base {
  include monitoring
  include puppet::cronjob
  include users::groups::govuk
  include hosts::elms-preview
  include mongodb::server

  case $::govuk_provider {
    sky: {
      case $::govuk_platform {
        production: {
          $mongo_hosts = [
            'licensify-mongo-1.frontend-sky.production.internal',
            'licensify-mongo-2.frontend-sky.production.internal',
            'licensify-mongo-3.frontend-sky.production.internal'
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
        preview: {
          $mongo_hosts = [
            'elms-mongo-1',
            'elms-mongo-2',
            'elms-mongo-3'
          ]
        }
        default: {
          $mongo_hosts = ['localhost']
        }
      }
    }
  }

  class {'mongodb::configure_replica_set':
    members => $mongo_hosts
  }
}

class elms_base::frontend_server inherits elms_base {
  include monitoring
  include puppet::cronjob
  include users::groups::govuk
  include hosts::elms-preview
  class { 'nginx': }
  class { 'licensify':
    require => Class['nginx']
  }
}

class elms_base::development inherits elms_base {
  host { 'elms-frontend': ip => '127.0.0.1' }
  host { 'elms-mongo-1':  ip => '127.0.0.1' }

  class { 'nginx': }
  class { 'licensify':
    require => Class['nginx']
  }

  include mongodb::server
  class {'mongodb::configure_replica_set':
    members => ['elms-mongo-1'],
  }
}
