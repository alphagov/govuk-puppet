# == Class: monitoring::checks::mirror
#
# Nagios alerts for Mirror staleness.
#
# === Parameters
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

    icinga::host { "mirror0.${provider0_subdomain}":
      host_name    => 'mirror0.provider0',
      hostalias    => "mirror0.${provider0_subdomain}",
      address      => "mirror0.${provider0_subdomain}",
      display_name => 'mirror0.provider0',
    }

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

    icinga::host { "mirror1.${provider0_subdomain}":
      host_name    => 'mirror1.provider0',
      hostalias    => "mirror1.${provider0_subdomain}",
      address      => "mirror1.${provider0_subdomain}",
      display_name => 'mirror1.provider0',
    }

    icinga::host { "mirror0.${provider1_subdomain}":
      host_name    => 'mirror0.provider1',
      hostalias    => "mirror0.${provider1_subdomain}",
      address      => "mirror0.${provider1_subdomain}",
      display_name => 'mirror0.provider1',
    }

    icinga::host { "mirror1.${provider1_subdomain}":
      host_name    => 'mirror1.provider1',
      hostalias    => "mirror1.${provider1_subdomain}",
      address      => "mirror1.${provider1_subdomain}",
      display_name => 'mirror1.provider1',
    }

    icinga::check { 'check_mirror0_provider0_disk':
      check_command       => 'check_nrpe_1arg!check_disk',
      service_description => 'low available disk space',
      use                 => 'govuk_high_priority',
      host_name           => "mirror0.${provider0_subdomain}",
      require             => Icinga::Host["mirror0.${provider0_subdomain}"],
    }

    icinga::check { 'check_mirror1_provider0_disk':
      check_command       => 'check_nrpe_1arg!check_disk',
      service_description => 'low available disk space',
      use                 => 'govuk_high_priority',
      host_name           => "mirror1.${provider0_subdomain}",
      require             => Icinga::Host["mirror1.${provider0_subdomain}"],
    }

    icinga::check { 'check_mirror0_provider1_disk':
      check_command       => 'check_nrpe_1arg!check_disk',
      service_description => 'low available disk space',
      use                 => 'govuk_high_priority',
      host_name           => "mirror0.${provider1_subdomain}",
      require             => Icinga::Host["mirror0.${provider1_subdomain}"],
    }

    icinga::check { 'check_mirror1_provider1_disk':
      check_command       => 'check_nrpe_1arg!check_disk',
      service_description => 'low available disk space',
      use                 => 'govuk_high_priority',
      host_name           => "mirror1.${provider1_subdomain}",
      require             => Icinga::Host["mirror1.${provider1_subdomain}"],
    }

    icinga::check { 'check_mirror0_provider0_disk_mirror-data':
      check_command       => 'check_nrpe_1arg!check_disk_mirror-data',
      service_description => 'low available disk space on /srv/mirror_data',
      use                 => 'govuk_high_priority',
      host_name           => "mirror0.${provider0_subdomain}",
    }

    icinga::check { 'check_mirror1_provider0_disk_mirror-data':
      check_command       => 'check_nrpe_1arg!check_disk_mirror-data',
      service_description => 'low available disk space on /srv/mirror_data',
      use                 => 'govuk_high_priority',
      host_name           => "mirror1.${provider0_subdomain}",
    }

    icinga::check { 'check_mirror0_provider1_disk_mirror-data':
      check_command       => 'check_nrpe_1arg!check_disk_mirror-data',
      service_description => 'low available disk space on /srv/mirror_data',
      use                 => 'govuk_high_priority',
      host_name           => "mirror0.${provider1_subdomain}",
    }

    icinga::check { 'check_mirror1_provider1_disk_mirror-data':
      check_command       => 'check_nrpe_1arg!check_disk_mirror-data',
      service_description => 'low available disk space on /srv/mirror_data',
      use                 => 'govuk_high_priority',
      host_name           => "mirror1.${provider1_subdomain}",
    }
  }
}
