# == Class: monitoring::checks::mirror
#
# Nagios alerts for Mirror staleness.
#
# === Variables:
#
# [*mirror_enable_checks*]
#   Can be used to disable checks/alerts for a given environment.
#   Default: no
#
class monitoring::checks::mirror {
  nagios::check_config { 'mirror_age':
    source => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_mirror_age.cfg',
  }

  # Not exported resources, so they will be purged when bool is false.
  $mirror_enable_checks = str2bool(extlookup('mirror_enable_checks', 'no'))

  if $mirror_enable_checks {
    $mirror_subdomain = 'mirror.provider0.production.govuk.service.gov.uk'
    $mirror_vhost     = "www-origin.${mirror_subdomain}"

    nagios::check { 'check_mirror0_up_to_date':
      check_command       => "check_mirror_age!mirror0.${mirror_subdomain}!${mirror_vhost}",
      host_name           => $::fqdn,
      service_description => 'mirror0 site out of date',
    }

    nagios::check { 'check_mirror1_up_to_date':
      check_command       => "check_mirror_age!mirror1.${mirror_subdomain}!${mirror_vhost}",
      host_name           => $::fqdn,
      service_description => 'mirror1 site out of date',
    }
  }
}
