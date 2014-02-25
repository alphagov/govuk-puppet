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
define icinga::check (
  $host_name,
  $ensure                     = 'present',
  $service_description        = undef,
  $check_command              = undef,
  $notification_period        = undef,
  $use                        = 'govuk_regular_service',
  $action_url                 = undef,
  $notes_url                  = undef,
  $check_interval             = undef,
  $retry_interval             = undef,
  $first_notification_delay   = undef,
  $attempts_before_hard_state = undef
) {

  $check_filename = "/etc/icinga/conf.d/icinga_host_${host_name}/${title}.cfg"

  if $ensure == 'present' {

    if $service_description == undef {
      fail("Must provide a \$service_description to icinga::Check[${title}]")
    }

    if $check_command == undef {
      fail("Must provide a \$check_command to icinga::Check[${title}]")
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
