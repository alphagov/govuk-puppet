# == Define: govuk::procfile::worker
#
# Creates an upstart entry for a worker as defined by the application's Procfile.
#
# === Parameters
#
# [*enable_service*]
#   Whether or not to start the service.  Always false if $ensure is 'absent'.
#   Default: true
#
# [*ensure*]
#   Whether to create or remove the configuration file.
#   Default: present
#
# [*process_type*]
#   The type of process to spawn, defined in the application's Procfile.
#   This variable is used by the govuk/procfile-worker_child.conf.erb template.
#   Default: 'worker'
#
# [*setenv_as*]
#   The application name to use when calling `govuk_setenv`.
#   This variable is used by the govuk/procfile-worker_child.conf.erb template.
#   Default: $title
#
# [*process_count*]
#   The number of instances to run of this procfile worker.
#   This variable is used by the govuk/procfile-worker.conf.erb template.
#   Default: 1
#
define govuk::procfile::worker (
  $enable_service = true,
  $ensure = present,
  $process_type = 'worker',
  $setenv_as = $title,
  $process_count = 1,
) {
  validate_re($ensure, '^(present|absent)$', '$ensure must be "present" or "absent"')

  include govuk::procfile

  $service_name = "${title}-procfile-worker"

  if $ensure == present {
    file { "/etc/init/${service_name}.conf":
      ensure    => present,
      content   => template('govuk/procfile-worker.conf.erb'),
      notify    => Service[$service_name],
      subscribe => Class['Govuk::Procfile'],
    }

    file { "/etc/init/${service_name}_child.conf":
      ensure    => present,
      content   => template('govuk/procfile-worker_child.conf.erb'),
      notify    => Service[$service_name],
      subscribe => Class['Govuk::Procfile'],
    }

    service { $service_name:
      ensure => $enable_service,
    }

    if $enable_service {
      @@icinga::check { "check_app_${title}_procfile_worker_upstart_up_${::hostname}":
        check_command       => "check_nrpe!check_upstart_status!${service_name}",
        service_description => "${title} procfile worker upstart up",
        host_name           => $::fqdn,
      }
    }
  } else {
    exec { "stop_service_${service_name}":
      command => "service ${service_name} stop",
      onlyif  => "service ${service_name} status | grep running",
    }

    file { "/etc/init/${service_name}.conf":
      ensure  => absent,
      require => Exec["stop_service_${service_name}"],
    }

    file { "/etc/init/${service_name}-child.conf":
      ensure  => absent,
      require => Exec["stop_service_${service_name}"],
    }
  }
}
