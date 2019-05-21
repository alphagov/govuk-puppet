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
# [*ensure*]
#   Default set to present, but set to absent to remove any associated checks.
#
# [*freshness_threshold*]
#   Raise a WARNING if no passive check submissions have been received
#   within this time period. Specified in seconds.
#   Default: none, freshness checks disabled.
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
# [*service_template*]
#   Which parent Icinga service to inherit from
#
# [*contact_groups*]
#   Convenience parameter to use in addition to the service
#   templates. This is so you can pass a group to a check without
#   having to define a new service template
#
define icinga::passive_check (
  $service_description,
  $host_name,
  $ensure                  = 'present',
  $freshness_threshold     = '',
  $freshness_alert_level   = 'warning',
  $freshness_alert_message = 'Freshness threshold exceeded',
  $action_url              = undef,
  $notes_url               = undef,
  $service_template        = 'govuk_regular_service',
  $contact_groups          = undef,
){

  validate_re($service_description, '^(\w|\s|\-|/|\[|\]|:|\.)*$', "Icinga check \"${service_description}\" contains invalid characters")
  validate_re($freshness_alert_level, '^(warning|critical)$')

  $active_message = $freshness_threshold ? {
    ''      => 'Unexpected active check on passive service',
    default => $freshness_alert_message,
  }

  $active_code = $freshness_alert_level ? { 'critical' => '2', default => '1' }

  Icinga::Host[$host_name] -> Icinga::Passive_check[$title]

  file { "/etc/icinga/conf.d/icinga_host_${host_name}/${title}.cfg":
    ensure  => $ensure,
    content => template('icinga/passive_service.erb'),
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }
}
