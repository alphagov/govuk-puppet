class ertp_base {
  include base
  include hosts::ertp
  include puppet
  include users
  include users::groups::govuk
  include users::groups::ertp
  include govuk::deploy
  include govuk::repository
}

class ertp_base::mongo_server inherits ertp_base {
  include monitoring::client
  include puppet::cronjob

  include mongodb::server

  class {'mongodb::configure_replica_set':
    members => [
      'ertp-mongo-1',
      'ertp-mongo-2',
      'ertp-mongo-3'
    ]
  }
}

class ertp_base::frontend_server inherits ertp_base {
  include nginx
  include monitoring::client
  include puppet::cronjob

  case $::govuk_platform {
    staging: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/nginx/ertp-staging',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.staging':
        ensure  => present,
        source  => 'puppet:///modules/nginx/htpasswd.ertp.staging',
        require => Class['nginx::package'],
      }
    }
    default: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/nginx/ertp-preview',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.preview':
        ensure  => present,
        source  => 'puppet:///modules/nginx/htpasswd.ertp.preview',
        require => Class['nginx::package'],
      }
    }
  }

  include ertp::config
  include ertp::scripts
}

class ertp_base::api_server inherits ertp_base {
  include nginx
  include monitoring::client
  include puppet::cronjob

  case $::govuk_platform {
    staging: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-staging-api',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.staging':
        ensure  => present,
        source  => 'puppet:///modules/ertp/etc/nginx/htpasswd.ertp.api.staging',
        require => Class['nginx::package'],
      }
    }
    default: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-preview-api',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.preview':
        ensure  => present,
        source  => 'puppet:///modules/ertp/etc/nginx/htpasswd.ertp.api.preview',
        require => Class['nginx::package'],
      }
    }
  }

  include ertp::api::scripts
}

class ertp_base::api_server::dwp inherits ertp_base::api_server {
  include ertp::dwp::api::config
  include ertp::dwp::scripts
}

class ertp_base::api_server::ero inherits ertp_base::api_server {
  include ertp::ero::api::config
}

class ertp_base::api_server::citizen inherits ertp_base::api_server {
  include ertp::citizen::api::config
}

class ertp_base::api_server::all inherits ertp_base::api_server {
  include ertp::config
  include ertp::dwp::scripts
}
