# == Class: Govuk_docker::Logspout
#
# Run the logspout shipping container
#
# === Parameters:
#
# [*endpoint*]
#   Where the logs should be shipped to.
#   Default: 127.0.0.1:4242
#
# [*tags*]
#   An array of tags to be appended to the logs. The logs will always be tagged
#   with 'docker' and 'json_log' to aid identification.
#   Default: []
#
# [*image_tag*]
#   Tag version of the container to use.
#   Default: 'latest'
#
class govuk_docker::logspout (
  $endpoint      = '127.0.0.1:4242',
  $tags          = [],
  # TODO publish a specific version and use that here
  $image_tag     = 'latest',
) {
  validate_array($tags)
  validate_string($endpoint)

  $image_name = 'govuk/logspout-alpine'

  $tag_list = join(concat($tags, ['docker', 'json_log']), ',')
  $tag_env = "LOGSTASH_TAGS=${tag_list}"

  ::docker::image { $image_name:
    ensure    => 'present',
    image_tag => $image_tag,
  }

  ::docker::run { 'logspout':
    image            => "${image_name}:${image_tag}",
    require          => Docker::Image[$image_name],
    env              => [$tag_env],
    volumes          => ['/var/run/docker.sock:/var/run/docker.sock'],
    command          => "logstash+tls://${endpoint}",
    extra_parameters => ['--restart=on-failure:16'],
  }

  @@icinga::check { "check_logspout_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!logspout',
    service_description => 'logspout running',
    host_name           => $::fqdn,
  }
}
