class licensify::apps {
  include licensify::apps::licensify
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed
}

class licensify::apps::licensify( $port = 9000 ) {
  include licensify::config

  file { '/etc/gds-licensify-config.conf':
    ensure => present,
    source => [
                "puppet:///modules/licensify/gds-licensify-config.properties.${::govuk_platform}.${::govuk_provider}",
                "puppet:///modules/licensify/gds-licensify-config.properties.${::govuk_platform}",
              ]
  }

  govuk::app { 'licensify':
    app_type           => 'procfile',
    port               => $port,
    environ_content    => template('licensify/environ'),
    nginx_extra_config => template('licensify/nginx_extra'),
    require            => File['/etc/gds-licensify-config.conf'],
    health_check_path  => '/'
  }

  nginx::config::vhost::licensify_upload{ 'licensify':}
  licensify::build_clean { 'licensify': }

}

class licensify::apps::licensify_admin( $port = 9500 ) {
  include licensify::config

  file { '/etc/gds-licensify-admin-config.conf':
    ensure => present,
    source => [
                "puppet:///modules/licensify/gds-licensify-admin-config.properties.${::govuk_platform}.${::govuk_provider}",
                "puppet:///modules/licensify/gds-licensify-admin-config.properties.${::govuk_platform}",
              ]
  }

  govuk::app { 'licensify-admin':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('licensify/environ'),
    vhost_protected => false,
    require         => File['/etc/gds-licensify-admin-config.conf'],
  }

  licensify::build_clean { 'licensify-admin': }
}

class licensify::apps::licensify_feed( $port = 9400 ) {
  include licensify::config

  file { '/etc/gds-licensify-feed-config.conf':
    ensure => present,
    source => [
                "puppet:///modules/licensify/gds-licensify-feed-config.properties.${::govuk_platform}.${::govuk_provider}",
                "puppet:///modules/licensify/gds-licensify-feed-config.properties.${::govuk_platform}",
              ]
  }

  govuk::app { 'licensify-feed':
    app_type        => 'procfile',
    port            => $port,
    environ_content => template('licensify/environ'),
    require         => File['/etc/gds-licensify-feed-config.conf'],
  }

  licensify::build_clean { 'licensify-feed': }
}
