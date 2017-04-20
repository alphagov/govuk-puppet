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
  $command = undef,
  $restart_attempts = 3,
) {
  require ::govuk_docker

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
    image            => "${image}:${image_tag}",
    ports            => [$exposed_port],
    env              => $envvars,
    command          => $command,
    extra_parameters => $extra_params,
    require          => Docker::Image[$image],
  }

  @@icinga::check { "${title}_process_${::hostname}":
    check_command       => "check_nrpe!check_proc_running!${title}",
    service_description => "${title} running",
    host_name           => $::fqdn,
  }
}
