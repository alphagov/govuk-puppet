# == Class: Govuk_containers::Grafana
#
# Run Grafana as a container for easier upgrades
#
# === Parameters
#
# [*image*]
#   Docker image name to use.
#
# [*tag*]
#   The docker tag to use.
#
class govuk_containers::grafana (
  $image = 'grafana/grafana',
  $tag = '4.5.2',
) {
  file { ['/var/lib/grafana', '/etc/grafana']:
    ensure => directory,
  }

  class { '::grafana::dashboards':
    require => File['/etc/grafana'],
  }

  file { '/etc/grafana/grafana.ini':
    ensure  => file,
    source  => 'puppet:///modules/grafana/grafana.ini',
    require => File['/etc/grafana'],
  }

  ::docker::image { $image:
    ensure    => 'present',
    require   => Class['govuk_docker'],
    image_tag => $tag,
  }

  ::docker::run { 'grafana':
    net              => 'host',
    ports            => ['3000:3000'],
    image            => $image,
    volumes          => ['/var/lib/grafana:/var/lib/grafana', '/etc/grafana:/etc/grafana'],
    require          => [
      Docker::Image[$image],
      File['/etc/grafana/grafana.ini'],
      Class['grafana::dashboards'],
    ],
  }

  @@icinga::check { "check_grafana_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!grafana',
    service_description => 'grafana running',
    host_name           => $::fqdn,
  }

  if $::aws_migration {
    nginx::config::vhost::proxy { 'grafana':
      to           => ['localhost:3000'],
      root         => '/usr/share/grafana',
      aliases      => ['grafana.*'],
      protected    => false,
      ssl_only     => true,
      ssl_certtype => 'wildcard_publishing',
    }
  } else {
    nginx::config::site { 'grafana':
      source => 'puppet:///modules/grafana/vhost.conf',
    }
  }
}
