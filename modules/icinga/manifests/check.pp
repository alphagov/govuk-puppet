# == Define: icinga::check
#
# Most of these params relate to Nagios service configuration directives:
#
# http://icinga.sourceforge.net/docs/3_0/objectdefinitions.html#service
#
# === Parameters:
#
# [*ensure*]
#   Can be used to remove an existing check.
#   Default: present
#
# [*service_description*]
#   Description of the alert.
#
# [*check_command*]
#   Command used to check whether the service is healthy.
#
# [*host_name*]
#   The title of a `Icinga::Host` resource. Usually `$::fqdn`.
#
#   This is a mandatory argument because the type is typically used as an
#   exported resource. In which case the variable must be eagerly evaluated
#   when passed by the exporting node, rather than lazily evaluated inside
#   the define by the collecting node.
#
# [*notification_period*]
#   The title of a `Icinga::Timeperiod` resource.
#
# [*use*]
#   The title of a `Icinga::Service_template` resource which this service
#   should inherit.
#   Default: govuk_regular_service
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
# [*linked_metric*]
#   A metric to link to in Graphite as part of the `action_url`. Overrides
#   the `$action_url` parameter if it's set.
#
# [*contact_groups*]
#   Convenience method to use in addition to the service
#   templates. This is so you can pass a group to a check without
#   having to define a new service template
#
# [*event_handler*]
#   A command to run when the check changes state
#
define icinga::check (
  $host_name,
  $ensure                     = 'present',
  $service_description        = undef,
  $check_command              = undef,
  $notification_period        = undef,
  $use                        = 'govuk_regular_service',
  $action_url                 = undef,
  $notes_url                  = undef,
  $linked_metric              = undef,
  $check_interval             = undef,
  $retry_interval             = undef,
  $first_notification_delay   = undef,
  $attempts_before_hard_state = undef,
  $contact_groups             = undef,
  $event_handler              = undef,
) {

  validate_re($service_description, '^(\w|\s|\-|/|\[|\]|:|\.)*$', "Icinga check \"${service_description}\" contains invalid characters")

  $app_domain = hiera('app_domain')
  $graph_width = 1000
  $graph_height = 600

  $check_filename = "/etc/icinga/conf.d/icinga_host_${host_name}/${title}.cfg"

  if $ensure == 'present' {

    if $service_description == undef {
      fail("Must provide a \$service_description to icinga::Check[${title}]")
    }

    if $check_command == undef {
      fail("Must provide a \$check_command to icinga::Check[${title}]")
    }

    if $linked_metric {
      $action_url_real = "https://graphite.${app_domain}/render/?\
width=${graph_width}&height=${graph_height}&target=${linked_metric}"
    } else {
      $action_url_real = $action_url
    }

    $check_content = template('icinga/service.erb')

    Icinga::Host[$host_name] -> Icinga::Check[$title]

  } else {
    $check_content = ''
  }

  file { $check_filename:
    ensure  => $ensure,
    content => $check_content,
    require => Class['icinga::package'],
    notify  => Class['icinga::service'],
  }

}
