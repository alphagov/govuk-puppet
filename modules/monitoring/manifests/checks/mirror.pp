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
# [*gcp_mirror_sync_project_id*]
#   Sets the GCP project id to use for the transfer job.
#   Required if enabled=true.
#
# [*gcp_mirror_sync_transfer_job_auth_json*]
#   Sets the auth JSON required by the Google SDK.
#   Required if enabled=true.
#
class monitoring::checks::mirror (
  $enabled = false,
  $gcp_mirror_sync_project_id = undef,
  $gcp_mirror_sync_transfer_job_auth_json = undef,
) {
  icinga::check_config { 'mirror_age':
    source => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_mirror_age.cfg',
  }

  if $enabled {
    $google_application_credentials_file_path = '/etc/govuk/gcloud_auth.json'

    file { $google_application_credentials_file_path:
      ensure  => present,
      content => $gcp_mirror_sync_transfer_job_auth_json,
      mode    => '0755',
      owner   => 'nagios',
      group   => 'nagios',
    }

    icinga::plugin { 'check_mirror_file_sync':
      source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_mirror_file_sync',
    }

    icinga::check_config { 'mirror_file_sync':
      source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_mirror_file_sync.cfg',
      require => File[$google_application_credentials_file_path],
    }

    icinga::check { 'check_mirror_file_sync':
      check_command       => "check_mirror_file_sync!${google_application_credentials_file_path}!${gcp_mirror_sync_project_id}",
      service_description => 'Check status of latest GCP mirror sync job',
      use                 => 'govuk_normal_priority',
      check_interval      => 1440,
      host_name           => $::fqdn,
    }

    $provider1_subdomain = 'mirror.provider1.production.govuk.service.gov.uk'
    $provider1_vhost     = "www-origin.${provider1_subdomain}"

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
