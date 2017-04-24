# == Class: govuk_containers::gemstash
#
# Install and run a dockerised Gemstash server
#
# === Parameters
#
# [*gemstash_image*]
#   Docker image name to use for the gemstash container.
#
# [*gemstash_image_version*]
#   The docker image version use.
#
class govuk_containers::gemstash(
  $gemstash_image = 'govuk/gemstash-alpine',
  # TODO publish a specific version and use that here
  $gemstash_image_version = 'latest',
) {

  file { '/var/lib/gemstash':
    ensure => directory,
  }

  ::docker::image { $gemstash_image:
    ensure    => 'present',
    require   => Class['govuk_docker'],
    image_tag => $gemstash_image_version,
  }

  ::docker::run { 'gemstash':
    net              => 'host',
    ports            => ['9292:9292'],
    image            => $gemstash_image,
    require          => Docker::Image[$gemstash_image],
    volumes          => ['/var/lib/gemstash:/root/.gemstash'],
    extra_parameters => ['-P'],
  }

  @@icinga::check { "check_gemstash_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!gemstash',
    service_description => 'gemstash running',
    host_name           => $::fqdn,
  }
}
