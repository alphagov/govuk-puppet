# == Class: icinga::client::check_cputype
#
# Checks if the CPU matches the defined model type
#
# === Parameters
#
# [*cputype*]
# Defines what CPU model type to check for, for example
# either "intel" or "amd" (lowercase only).
#
class icinga::client::check_cputype (
  $cputype = 'intel',
) {

  @icinga::plugin { 'check_cputype':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_cputype',
  }

  @@icinga::check { "check_cputype_on_${::hostname}":
    check_command       => "check_nrpe!check_cputype!${cputype}",
    service_description => 'defined cpu type does not match',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(defined-cpu-type-does-not-match),
  }
}
