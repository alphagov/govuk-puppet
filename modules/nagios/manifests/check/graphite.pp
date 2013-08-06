# == Define: nagios::check::graphite
#
# Wrapper for `nagios::check` that references `check_graphite` and creates
# an alert with the appropriate `action_url` link to a graph containing
# warning and critical bands.
#
# It is deliberately quite simple and doesn't take many arguments, which
# will result in the defaults from `nagios::check`. It can be extended as
# necessary.
#
# === Parameters
#
# [*target*]
#   Graphite expression that will return a single metric. See:
#   http://graphite.readthedocs.org/en/1.0/url-api.html#target
#
# [*desc*]
#   Description of the Nagios alert. Will be passed to the `nagios::check`
#   param `service_description`.
#
# [*warning*]
#   Integer that will raise a warning alert.
#
# [*critical*]
#   Integer that will raise a critical alert.
#
# [*host_name*]
#   Passed to `nagios::check` as `host_name`. Usually `$::fqdn`.
#
#   This is a mandatory argument because the type is typically used as an
#   exported resource. In which case the variable must be eagerly evaluated
#   when passed by the exporting node, rather than lazily evaluated inside
#   the define by the collecting node.
#
# [*args*]
#   Single string of additional arguments passed to `check_graphite_args`.
#   Default: ''
#
# [*from*]
#   Single string representing a time period passed to `check_graphite_args`.
#   Default: '5minutes'
#
# [*document_url*]
#   FIXME: Provide backwards compat when moving to `notes_url`. To be
#   removed after first deployment.
#
# [*notes_url*]
#   Passed to `nagios::check`. See there for documentation.
#   Default: undef
#
define nagios::check::graphite(
  $target,
  $desc,
  $warning,
  $critical,
  $host_name,
  $args = '',
  $from = '5minutes',
  $document_url = 'DEPRECATED',
  $notes_url = undef
) {
  $check_command = 'check_graphite_metric_args'
  $args_real = "-F ${from} ${args}"
  $url_encoded_target = regsubst($target, '"', '%22', 'G')

  $monitoring_domain_suffix = extlookup('monitoring_domain_suffix', '')
  $graph_width = 600
  $graph_height = 300

  nagios::check { $title:
    check_command              => "${check_command}!${target}!${warning}!${critical}!${args_real}",
    service_description        => $desc,
    host_name                  => $host_name,
    action_url                 => "https://graphite.${monitoring_domain_suffix}/render/?\
width=${graph_width}&height=${graph_height}&\
target=${url_encoded_target}&\
target=alias(dashed(constantLine(${warning})),%22warning%22)&\
target=alias(dashed(constantLine(${critical})),%22critical%22)",
    notes_url                  => $notes_url,
    attempts_before_hard_state => 1,
  }
}
