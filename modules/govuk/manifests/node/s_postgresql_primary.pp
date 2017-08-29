# == Class: govuk::node::s_postgresql_primary
#
# PostgreSQL primary node for main cluster.
#
# === Parameters:
#
# [*standby_password*]
#   Proxied to `govuk_postgresql::server::primary` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_postgresql_primary (
  $standby_password,
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_url,
  $wale_private_gpg_key,
  $wale_private_gpg_key_fingerprint,
  $alert_hostname = 'alert.cluster',
) inherits govuk::node::s_postgresql_base {
  class { 'govuk_postgresql::server::primary':
    slave_password => $standby_password,
  }

  govuk_postgresql::wal_e::backup { $title:
    aws_access_key_id                => $aws_access_key_id,
    aws_secret_access_key            => $aws_secret_access_key,
    s3_bucket_url                    => $s3_bucket_url,
    wale_private_gpg_key             => $wale_private_gpg_key,
    wale_private_gpg_key_fingerprint => $wale_private_gpg_key_fingerprint,
    alert_hostname                   => $alert_hostname,
  }
}
