# == Define: icinga::passive_check
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
#   The title of a `Icinga::Host` resource. Usually `$::fqdn`.
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
#
# [*action_url*]
#   Additional diagnostics URL. Typically a link to a graph in Graphite that
#   shows very recent trends for the service. This will be included in the
#   Nagios UI and email alerts.
#
# [*notes_url*]
#   Documentation URL for more information about how to diagnose the service
#   and why the alert might exist. Should link to a section of the
#   "opsmanual". This will be included in the Nagios UI and email alerts.
#
define icinga::passive_check (
  $service_description,
  $host_name,
  $freshness_threshold = '',
  $action_url          = undef,
  $notes_url           = undef
){
  $active_message = $freshness_threshold ? {
    ''      => 'Unexpected active check on passive service',
    default => 'Freshness threshold exceeded',
  }

  Icinga::Host[$host_name] -> Icinga::Passive_check[$title]

  file { "/etc/icinga/conf.d/icinga_host_${host_name}/${title}.cfg":
    ensure  => present,
    content => template('icinga/passive_service.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }
}
