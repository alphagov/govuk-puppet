# == Class: govuk::node::s_transition_postgresql_master
#
# PostgreSQL master node for Transition.
#
# === Parameters:
#
# [*slave_password*]
#   Proxied to `govuk_postgresql::server::primary` so that we can set
#   per-cluster passwords in a single hiera credentials file.
#
class govuk::node::s_transition_postgresql_master (
  $slave_password,
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_url,
  $wale_private_gpg_key,
  $wale_private_gpg_key_fingerprint,
  $env_sync_access_key_id = undef,
  $env_sync_secret_access_key = undef,
  $env_sync_s3_bucket_url = undef,
  $env_sync_private_gpg_key = undef,
  $env_sync_private_gpg_key_fingerprint = undef,
  $env_sync_private_gpg_key_passphrase = undef,
  $env_sync_enabled = false,
) inherits govuk::node::s_transition_postgresql_base {
  class { 'govuk_postgresql::server::primary':
    slave_password => $slave_password,
  }

  govuk_postgresql::wal_e::backup { $title:
    aws_access_key_id                => $aws_access_key_id,
    aws_secret_access_key            => $aws_secret_access_key,
    s3_bucket_url                    => $s3_bucket_url,
    wale_private_gpg_key             => $wale_private_gpg_key,
    wale_private_gpg_key_fingerprint => $wale_private_gpg_key_fingerprint,
  }

  if $env_sync_enabled {
    govuk_postgresql::wal_e::env_sync { $title:
      aws_access_key_id                => $env_sync_access_key_id,
      aws_secret_access_key            => $env_sync_secret_access_key,
      s3_bucket_url                    => $env_sync_s3_bucket_url,
      wale_private_gpg_key             => $env_sync_private_gpg_key,
      wale_private_gpg_key_fingerprint => $env_sync_private_gpg_key_fingerprint,
      wale_private_gpg_key_passphrase  => $env_sync_private_gpg_key_passphrase,
    }
  }

  include govuk::apps::bouncer::postgresql_role
}
