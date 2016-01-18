# == Define: icinga::service_dependency
#
# This creates a service dependency for the host service that other host
# services are dependent on.
#
# Most of these params relate to Nagios service configuration directives:
#
# https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/3/en/objectdefinitions.html#servicedependency
#
# === Parameters:
#
# [*dependent_host_name*]
#   This host is dependent on `host_name`. The title of an `Icinga::Host`
#   resource, usually `$::fqdn`.
#
# [*host_name*]
#   The host upon which the service that causes the dependency runs on.
#
# [*service_description*]
#   Description of the service that is dependent services rely upon.
#
# [*check_command*]
#   Command used to check whether the service is healthy.
#
# [*dependent_service_decription*]
#   Description of the service where functionality is changed depending on the
#   status of `service_description`.
#
# [*execution_failure_criteria*]
#   A comma-seperated set of criteria that determine what state the service is
#   in for how actively the dependent service is checked.
#   Default: 'n': none (services are always checked)
#
# [*notifcation_failure_criteria*]
#   A comma-seperated set of criteria that determines when notifcations should
#   suppressed for the dependent service.
#   Default: 'w,c': warning state, critical state
#
define icinga::service_dependency (
  $dependent_host_name,
  $host_name                      = undef,
  $service_description            = undef,
  $dependent_service_description  = undef,
  $execution_failure_criteria     = 'n',
  $notification_failure_criteria  = 'w,c',
) {

  validate_re($service_description, '^(\w|\s|\-|/|\[|\]|:|\.)*$', "Icinga check \"${dependent_service_description}\" contains invalid characters")

  if $service_description == undef {
    fail("Must provide a \$service_description to Icinga::Service_dependency[${title}]")
  }
  if $dependent_service_description == undef {
    fail("Must provide a \$dependent_service_description to Icinga::Service_dependency[${title}]")
  }

  if $dependent_host_name == undef {
    fail("Must provide a \$host_name to Icinga::Service_dependency[${title}]")
  }

  $filename = "/etc/icinga/conf.d/icinga_host_${dependent_host_name}/${title}.cfg"
  $content = template('icinga/service_dependency.erb')

  Icinga::Host[$host_name] -> Icinga::Service_dependency[$title]

  file { $filename:
    ensure  => present,
    content => $content,
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
