class elms_base {
  include base
  include hosts
  include monitoring::client
  include java::openjdk6::jre
  include puppet
  include puppet::cronjob
  include users
  include users::groups::govuk

  include govuk::repository
  include govuk::deploy

  case $::govuk_provider {
    sky: {
      # hosts managed as part of hosts module
    }
    scc: {
      # nothing
    }
    default: {
      case $::govuk_platform {
        production: {
          host { 'licensify-frontend': ip => '10.229.67.16' }
          host { 'licensify-mongo0':   ip => '10.32.34.170' }
          host { 'licensify-mongo1':   ip => '10.239.11.229' }
          host { 'licensify-mongo2':   ip => '10.32.57.17' }
        }
        preview: {
          host { 'licensify-frontend': ip => '10.237.35.45' }
          host { 'licensify-mongo0':   ip => '10.234.74.235' }
          host { 'licensify-mongo1':   ip => '10.229.30.142' }
          host { 'licensify-mongo2':   ip => '10.234.81.24' }
          host { 'places-api':         ip => '10.229.118.175' }
        }
        default: {}
      }
    }
  }

}

class elms_base::mongo_server inherits elms_base {
  include mongodb::server

  case $::govuk_provider {
    sky: {
      $mongo_hosts = [
        'elms-mongo-1.backend.production',
        'elms-mongo-2.backend.production',
        'elms-mongo-3.backend.production'
      ]
    }
    #aws
    default: {
      $mongo_hosts = [
        'licensify-mongo0',
        'licensify-mongo1',
        'licensify-mongo2'
      ]
    }
  }

  class { 'mongodb::configure_replica_set':
    members => $mongo_hosts
  }
}

class elms_base::frontend_server inherits elms_base {
  include clamav

  class { 'nginx': }
  class { 'licensify':
    require => Class['nginx']
  }
}
