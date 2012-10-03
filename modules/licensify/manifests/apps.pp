class licensify::apps::base {
  $aws_access_key_id = extlookup('aws_access_key_id', '')
  $aws_secret_key = extlookup('aws_secret_key', '')
}

class licensify::apps {
  include licensify::apps::licensify
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed
}

class licensify::apps::licensify( $port = 9000 ) inherits licensify::apps::base {
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
    health_check_path  => '/api/licences'
  }
  # Experimenting with app http checks
  if $::govuk_provider == 'sky'{
    @@nagios::check { "check_app_licensify_up_on_${::hostname}":
      check_command       => "check_nrpe!check_app_up!licensify.${::govuk_platform}.alphagov.co.uk!${port}!/api/licences",
      service_description => "check if app licensify is up on ${::govuk_class}-${::hostname}",
      host_name           => "${::govuk_class}-${::hostname}",
    }
  }

  nginx::config::vhost::licensify_upload{ 'licensify':}
  licensify::build_clean { 'licensify': }

}

class licensify::apps::licensify_admin( $port = 9500 ) inherits licensify::apps::base {
  include licensify::config

  file { '/etc/gds-licensify-admin-config.conf':
    ensure => present,
    source => [
                "puppet:///modules/licensify/gds-licensify-admin-config.properties.${::govuk_platform}.${::govuk_provider}",
                "puppet:///modules/licensify/gds-licensify-admin-config.properties.${::govuk_platform}",
              ]
  }

  govuk::app { 'licensify-admin':
    app_type          => 'procfile',
    port              => $port,
    environ_content   => template('licensify/environ'),
    vhost_protected   => false,
    require           => File['/etc/gds-licensify-admin-config.conf'],
    health_check_path => "/login"
  }

  licensify::build_clean { 'licensify-admin': }
}

class licensify::apps::licensify_feed( $port = 9400 ) inherits licensify::apps::base {
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
