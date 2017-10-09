# == Class: govuk_containers::terraboard
#
# Run Terraboard (https://github.com/camptocamp/terraboard)
#
class govuk_containers::terraboard (
  $image = 'camptocamp/terraboard',
  $tag   = 'latest',
) {
  include ::govuk_docker

  ::docker::run { 'postgres':
    image   => "postgres:alpine",
    ports   => ['5432:5432'],
    require => Class['::govuk_docker'],
    env     => $env,
  }

  $env_vars = [
  ]

  ::docker::run { 'terraboard':
    image   => "${image}:${tag}",
    ports   => ['8080:8080'],
    require => Docker::Run['postgres'],
    env     => $env_vars,
  }

  # Provide a symlink to the docker job using the plain app name
  file { "/etc/init.d/terraboard":
    ensure => 'link',
    target => "/etc/init.d/docker-terraboard",
  }

  nginx::config::vhost::proxy { 'terraboard':
    to        => ['localhost:8080'],
    root      => '/usr/share/grafana',
    aliases   => ['terraboard.*'],
    protected => false,
    root      => '/dev/null',
  }

  @@icinga::check { "check_terraboard_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!terraboard',
    service_description => 'terraboard running',
    host_name           => $::fqdn,
  }

}
