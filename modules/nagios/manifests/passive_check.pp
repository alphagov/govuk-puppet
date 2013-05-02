# == Define: nagios::passive_check
#
# Create a service with a passive check. Active checks will not be
# scheduled. Freshness checking can be enabled optionally.
#
# === Parameters
#
# [*service_description*]
#   Description of the alert.
#
# [*host_name*]
#   The title of a `Nagios::Host` resource. Usually `$::fqdn`.
#
#   This is a mandatory argument because the type is typically used as an
#   exported resource. In which case the variable must be eagerly evaluated
#   when passed by the exporting node, rather than lazily evaluated inside
#   the define by the collecting node.
#
# [*freshness_threshold*]
#   Raise a WARNING if no passive check submissions have been received
#   within this time period. Specified in seconds.
#   Default: none, freshness checks disabled.
#
define nagios::passive_check (
  $service_description,
  $host_name,
  $freshness_threshold = ''
){
  $active_message = $freshness_threshold ? {
    ''      => 'Unexpected active check on passive service',
    default => 'Freshness threshold exceeded',
  }

  Nagios::Host[$host_name] -> Nagios::Passive_check[$title]

  file { "/etc/nagios3/conf.d/nagios_host_${host_name}/${title}.cfg":
    ensure  => present,
    content => template('nagios/passive_service.erb'),
    require => Class['nagios::package'],
    notify  => Class['nagios::service'],
  }
}
