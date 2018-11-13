# == Class: govuk::node::s_postgresql_standby
#
# PostgreSQL standby node for main cluster.
#
# === Parameters:
#
# [*primary_password*]
#   Proxied to `govuk_postgresql::server::standby` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_postgresql_standby (
  $primary_password,
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_url,
  $wale_private_gpg_key,
  $wale_private_gpg_key_fingerprint,
) inherits govuk::node::s_postgresql_base {
  include govuk_env_sync
  class { 'govuk_postgresql::server::standby':
    master_password => $primary_password,
  }

  govuk_postgresql::wal_e::restore { $title:
    aws_access_key_id                => $aws_access_key_id,
    aws_secret_access_key            => $aws_secret_access_key,
    s3_bucket_url                    => $s3_bucket_url,
    wale_private_gpg_key             => $wale_private_gpg_key,
    wale_private_gpg_key_fingerprint => $wale_private_gpg_key_fingerprint,
  }
}
