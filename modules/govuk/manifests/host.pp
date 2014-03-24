# == Type: govuk::host
#
# Make defining a host that abides to GOV.UK convention easier. The
# resource's title should be the host unqualified name (e.g. `jumpbox-1`).
#
# === Parameters
#
# [*ensure*]
#   The desired state of the host entry, "present" or "absent".
#
# [*vdc*]
#   The host's destination virtual data centre, e.g. "management"
#
# [*ip*]
#   The host's IP address
#
# [*legacy_aliases*]
#   An array of legacy host aliases.
#
# [*service_aliases*]
#   An array of service names aliased to this host.
#
define govuk::host(
  $vdc,
  $ip,
  $ensure = present,
  $legacy_aliases = [],
  $service_aliases = [],

  # The following parameters should typically not be customized
  $service_suffix = 'cluster',
) {

  $tld = extlookup('internal_tld', 'production')

  $service_aliases_real = regsubst($service_aliases, '$', ".${service_suffix}")

  host { "${title}.${vdc}.${tld}":
    ensure       => $ensure,
    ip           => $ip,
    host_aliases => unique(flatten(["${title}.${vdc}", $service_aliases_real, $legacy_aliases])),
  }

}
