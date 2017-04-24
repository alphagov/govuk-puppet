# == Class: Govuk_containers::App::Config
#
# Basic configuration for apps running in containers
#
class govuk_containers::app::config (
  $global_envvars = [],
  $global_env_file = '/etc/global.env',
) {

  file { $global_env_file:
    ensure  => 'present',
    content => template('govuk_containers/global.env.erb'),
  }

}
