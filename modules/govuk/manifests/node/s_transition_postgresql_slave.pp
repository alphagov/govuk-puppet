# == Class: govuk::node::s_transition_postgresql_slave
#
# PostgreSQL slave node for Transition.
#
# === Parameters:
#
# [*master_password*]
#   Proxied to `govuk_postgresql::server::standby` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
# [*redirector_ip_range*]
#   Network range to allow access from Redirector.
#
class govuk::node::s_transition_postgresql_slave (
  $master_password,
  $redirector_ip_range,
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_url,
  $wale_private_gpg_key,
  $wale_private_gpg_key_fingerprint,
) inherits govuk::node::s_transition_postgresql_base {
  validate_string($redirector_ip_range)

  class { 'govuk_postgresql::server::standby':
    master_password => $master_password,
  }

  postgresql::server::pg_hba_rule { 'Allow access for bouncer role to transition_production database from redirector vDC':
    type        => 'host',
    database    => 'transition_production',
    user        => 'bouncer',
    address     => $redirector_ip_range,
    auth_method => 'md5',
  }

  govuk_postgresql::wal_e::restore { $title:
    aws_access_key_id                => $aws_access_key_id,
    aws_secret_access_key            => $aws_secret_access_key,
    s3_bucket_url                    => $s3_bucket_url,
    wale_private_gpg_key             => $wale_private_gpg_key,
    wale_private_gpg_key_fingerprint => $wale_private_gpg_key_fingerprint,
  }
}
