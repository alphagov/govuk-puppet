# == Define: icinga::check::graphite
#
# Wrapper for `icinga::check` that references `check_graphite` and creates
# an alert with the appropriate `action_url` link to a graph containing
# warning and critical bands.
#
# It is deliberately quite simple and doesn't take many arguments, which
# will result in the defaults from `icinga::check`. It can be extended as
# necessary.
#
# === Parameters
#
# [*target*]
#   Graphite expression that will return a single metric. See:
#   http://graphite.readthedocs.org/en/1.0/url-api.html#target
#
# [*desc*]
#   Description of the Nagios alert. Will be passed to the `icinga::check`
#   param `service_description`.
#
# [*warning*]
#   Integer that will raise a warning alert.
#
# [*critical*]
#   Integer that will raise a critical alert.
#
# [*host_name*]
#   Passed to `icinga::check` as `host_name`. Usually `$::fqdn`.
#
#   This is a mandatory argument because the type is typically used as an
#   exported resource. In which case the variable must be eagerly evaluated
#   when passed by the exporting node, rather than lazily evaluated inside
#   the define by the collecting node.
#
# [*use*]
#   The title of a `Icinga::Service_template` resource which this service
#   should inherit. The downstream default is `govuk_regular_service`
#   Default: undef
#
# [*args*]
#   Single string of additional arguments passed to `check_graphite_args`.
#   Default: ''
#
# [*from*]
#   Single string representing a time period passed to `check_graphite_args`.
#   Default: '5minutes'
#
# [*notes_url*]
#   Passed to `icinga::check`. See there for documentation.
#   Default: undef
#
# [*warning_command*]
#   Used in the url to graphite graph as a command to display the warning bounds
#   Default: alias(dashed(constantLine(${warning})),%22warning%22)
#
# [*critical_command*]
#   Used in the url to graphite graph as a command to display the critical bounds
#   Default: alias(dashed(constantLine(${critical})),%22critical%22)
#
define icinga::check::graphite(
  $target,
  $desc,
  $warning,
  $critical,
  $host_name,
  $use  = undef,
  $args = '',
  $from = '5minutes',
  $notes_url = undef,
  $warning_command = undef,
  $critical_command = undef,
) {

  $check_command = 'check_graphite_metric_args'
  $args_real = "-F ${from} ${args}"
  $url_encoded_target = regsubst($target, '"', '%22', 'G')

  $monitoring_domain_suffix = extlookup('monitoring_domain_suffix', '')
  $graph_width = 600
  $graph_height = 300

  if $warning_command == undef {
    $warning_target = "alias(dashed(constantLine(${warning})),%22warning%22)"
  } else {
    $warning_target = $warning_command
  }

  if $critical_command == undef {
    $critical_target = "alias(dashed(constantLine(${critical})),%22critical%22)"
  } else {
    $critical_target = $critical_command
  }

  icinga::check { $title:
    check_command              => "${check_command}!${target}!${warning}!${critical}!${args_real}",
    service_description        => $desc,
    host_name                  => $host_name,
    use                        => $use,
    action_url                 => "https://graphite.${monitoring_domain_suffix}/render/?\
width=${graph_width}&height=${graph_height}&\
target=${url_encoded_target}&\
target=${warning_target}&\
target=${critical_target}",
    notes_url                  => $notes_url,
    attempts_before_hard_state => 1,
  }

}
