# == Class: monitoring::checks::mirror
#
# Nagios alerts for Mirror staleness.
#
# === Variables:
#
# [*enabled*]
#   Can be used to disable checks/alerts for a given environment.
#   Default: false
#
class monitoring::checks::mirror (
  $enabled = false,
) {
  icinga::check_config { 'mirror_age':
    source => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_mirror_age.cfg',
  }

  if $enabled {
    $provider0_subdomain = 'mirror.provider0.production.govuk.service.gov.uk'
    $provider1_subdomain = 'mirror.provider1.production.govuk.service.gov.uk'
    $provider0_vhost     = "www-origin.${provider0_subdomain}"
    $provider1_vhost     = "www-origin.${provider1_subdomain}"

    icinga::check { 'check_mirror0_provider0_up_to_date':
      check_command       => "check_mirror_age!mirror0.${provider0_subdomain}!${provider0_vhost}",
      host_name           => $::fqdn,
      service_description => 'mirror0.provider0 site out of date',
    }

    icinga::check { 'check_mirror1_provider0_up_to_date':
      check_command       => "check_mirror_age!mirror1.${provider0_subdomain}!${provider0_vhost}",
      host_name           => $::fqdn,
      service_description => 'mirror1.provider0 site out of date',
    }

    icinga::check { 'check_mirror0_provider1_up_to_date':
      check_command       => "check_mirror_age!mirror0.${provider1_subdomain}!${provider1_vhost}",
      host_name           => $::fqdn,
      service_description => 'mirror0.provider1 site out of date',
    }

    icinga::check { 'check_mirror1_provider1_up_to_date':
      check_command       => "check_mirror_age!mirror1.${provider1_subdomain}!${provider1_vhost}",
      host_name           => $::fqdn,
      service_description => 'mirror1.provider1 site out of date',
    }
  }
}
