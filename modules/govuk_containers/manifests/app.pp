# == Class: Govuk_containers::App
#
# A defined type which pulls and runs a container with the defined environment
# variables.
#
# === Parameters:
#
# [*image*]
#   The container image to run.
#
# [*image_tag*]
#   The tag of the image to run.
#
# [*ports*]
#   An array of local ports to map in the format of ['1234:1234'].
#
# [*envvars*]
#   An array of environment variables to start the container with.
#
# [*global_env_file*]
#   Location of the file which holds global environment variables assigned
#   to every container that runs.
#
# [*command*]
#   A command to start the container with.
#
# [*extra_params*]
#   An array of extra paramaters to set.
#   Default is to always try restarting the app.
#
define govuk_containers::app (
  $image,
  $image_tag,
  $port,
  $envvars = [],
  $global_env_file = '/etc/global.env',
  $command = undef,
  $restart_attempts = 3,
) {
  require ::govuk_docker
  require ::govuk_containers::app::config

  validate_array($envvars)
  validate_re($restart_attempts, [ 'never', 'always', '^\d$' ])

  $exposed_port = "${port}:${port}"

  case $restart_attempts {
    'never':  { $restart_arg = '--restart=no' }
    'always': { $restart_arg = '--restart=always' }
    /\d/:   { $restart_arg = "--restart=on-failure:${restart_attempts}" }
    default: { $restart_arg = "--restart=on-failure:${restart_attempts}" }
  }

  # Add any extra parameters as an array
  $extra_params = [
    $restart_arg,
  ]

  ::docker::image { $image:
    ensure    => 'present',
    image_tag => $image_tag,
  }

  ::docker::run { $title:
    net              => 'host',
    image            => "${image}:${image_tag}",
    ports            => [$exposed_port],
    env              => $envvars,
    env_file         => $global_env_file,
    command          => $command,
    extra_parameters => $extra_params,
    require          => Docker::Image[$image],
    subscribe        => Class[Govuk_containers::App::Config],
  }

}
