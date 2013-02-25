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

  $ertp_http_username         = extlookup('ertp_http_username','')
  $ertp_preview_http_hash     = extlookup('ertp_preview_http_hash','')
  $ertp_staging_http_hash     = extlookup('ertp_staging_http_hash','')
  $ertp_api_preview_http_hash = extlookup('ertp_api_preview_http_hash','')
  $ertp_api_staging_http_hash = extlookup('ertp_api_staging_http_hash','')

  case $::govuk_platform {
    staging: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-staging',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.staging':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_staging_http_hash}\n",
        require => Class['nginx::package'],
      }
    }
    default: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-preview',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.preview':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_preview_http_hash}\n",
        require => Class['nginx::package'],
      }
    }
  }

  include ertp::config
  include ertp::scripts
}

class ertp_base::api_server inherits ertp_base {
  include monitoring::client
  include puppet::cronjob
  include ertp::api::scripts
}

class ertp_base::api_server::dwp inherits ertp_base::api_server {
  include ertp::dwp::api::config
  include ertp::dwp::scripts
  include nginx

  case $::govuk_platform {
    staging: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-staging-dwp-web-app',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.staging':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_api_staging_http_hash}\n",
        require => Class['nginx::package'],
      }
    }
    default: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-preview-api',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.preview':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_api_preview_http_hash}\n",
        require => Class['nginx::package'],
      }
    }
  }
}

class ertp_base::api_server::ero inherits ertp_base::api_server {
  include ertp::ero::api::config
  include nginx

  case $::govuk_platform {
    staging: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-staging-api',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.staging':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_api_staging_http_hash}\n",
        require => Class['nginx::package'],
      }
    }
    default: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-preview-api',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.preview':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_api_preview_http_hash}\n",
        require => Class['nginx::package'],
      }
    }
  }
}

class ertp_base::api_server::citizen inherits ertp_base::api_server {
  include ertp::citizen::api::config
}

class ertp_base::api_server::all inherits ertp_base::api_server {
  include nginx
  include ertp::config
  include ertp::dwp::scripts

  case $::govuk_platform {
    staging: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-staging-api',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.staging':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_api_staging_http_hash}\n",
        require => Class['nginx::package'],
      }
    }
    default: {
      nginx::config::site { 'default':
        source  => 'puppet:///modules/ertp/etc/nginx/ertp-preview-api',
      }

      file { '/etc/nginx/htpasswd/htpasswd.ertp.api.preview':
        ensure  => present,
        content => "${ertp_http_username}:${ertp_api_preview_http_hash}\n",
        require => Class['nginx::package'],
      }

      file { '/etc/nginx/ssl/server.key':
        ensure  => present,
        source  => 'puppet:///modules/ertp/etc/nginx/ssl/server.key',
        require => Class['nginx::package'],
      }

      file { '/etc/nginx/ssl/server.crt':
        ensure  => present,
        source  => 'puppet:///modules/ertp/etc/nginx/ssl/server.crt',
        require => Class['nginx::package'],
      }

      file { '/etc/nginx/ssl/ca.crt':
        ensure  => present,
        source  => 'puppet:///modules/ertp/etc/nginx/ssl/ca.crt',
        require => Class['nginx::package'],
      }
    }
  }
}
