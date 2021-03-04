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
# [*gcp_mirror_sync_transfer_job_name*]
#   Sets the transfer job name which controls the mirror sync.
#   Required if enabled=true.
#
class monitoring::checks::mirror (
  $enabled = false,
  $gcp_mirror_sync_project_id = undef,
  $gcp_mirror_sync_transfer_job_auth_json = undef,
  $gcp_mirror_sync_transfer_job_name = undef,
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
      check_command       => "check_mirror_file_sync!${google_application_credentials_file_path}!${gcp_mirror_sync_project_id}!${gcp_mirror_sync_transfer_job_name}",
      service_description => 'Check status of latest GCP mirror sync job',
      use                 => 'govuk_normal_priority',
      check_interval      => 1440,
      host_name           => $::fqdn,
    }
  }
}
