class elms_base {
  include base
  include hosts
  include monitoring::client
  include puppet
  include puppet::cronjob
  include users
  include users::groups::govuk

  include govuk::repository
  include govuk::deploy
}

class elms_base::mongo_server inherits elms_base {
  include mongodb::server
  include java::openjdk6::jre

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
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps':
    require => Class['nginx']
  }
}

class elms_base::sc_frontend_server inherits elms_base {
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps::licensify':
    require => Class['nginx']
  }
}

class elms_base::sc_backend_server inherits elms_base {
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps::licensify_admin':
    require => Class['nginx']
  }
  class { 'licensify::apps::licensify_feed':
    require => Class['nginx']
  }  
}
