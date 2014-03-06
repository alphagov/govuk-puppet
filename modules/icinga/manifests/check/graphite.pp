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
define icinga::check::graphite(
  $target,
  $desc,
  $warning,
  $critical,
  $host_name,
  $use  = undef,
  $args = '',
  $from = '5minutes',
  $warning_command = undef, #FIXME: remove once 9e17b79 is deployed everywhere
  $critical_command = undef, #FIXME: remove once 9e17b79 is deployed everywhere
  $action_url = undef,
  $notes_url = undef,
  $ensure = 'present',
) {
  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  $check_command = 'check_graphite_metric_args'
  $args_real = "-F ${from} ${args}"
  $url_encoded_target = regsubst($target, '"', '%22', 'G')

  $monitoring_domain_suffix = extlookup('monitoring_domain_suffix', '')
  $graph_width = 600
  $graph_height = 300

  # Only display lines when threshold is an integer or float.
  $warn_line = $warning ? {
    /^[0-9.]+$/ => "&target=alias(dashed(constantLine(${warning})),%22warning%22)",
    default    => '',
  }
  $crit_line = $critical ? {
    /^[0-9.]+$/ => "&target=alias(dashed(constantLine(${critical})),%22critical%22)",
    default    => '',
  }

  if $action_url == undef {
    $action_url_real = "https://graphite.${monitoring_domain_suffix}/render/?\
width=${graph_width}&height=${graph_height}&\
target=${url_encoded_target}\
${warn_line}${crit_line}"
  } else {
    $action_url_real = $action_url
  }

  icinga::check { $title:
    ensure                     => $ensure,
    check_command              => "${check_command}!${target}!${warning}!${critical}!${args_real}",
    service_description        => $desc,
    host_name                  => $host_name,
    use                        => $use,
    action_url                 => $action_url_real,
    notes_url                  => $notes_url,
    attempts_before_hard_state => 1,
  }
}
