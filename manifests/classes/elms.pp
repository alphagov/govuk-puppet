class elms_base {
  include base

  include puppet
  include users
  include openjdk
  include nagios::client
  include ganglia::client

  include govuk::repository
  include govuk::deploy
}

class elms_base::mongo_server inherits elms_base {
  include users::groups::govuk
  include hosts::elms-preview
  include mongodb::server

  class {'mongodb::configure_replica_set':
    members => [
      'elms-mongo-1',
      'elms-mongo-2',
      'elms-mongo-3'
    ]
  }
}

class elms_base::frontend_server inherits elms_base {
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
