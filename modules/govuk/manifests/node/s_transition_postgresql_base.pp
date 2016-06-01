# == Class: govuk::node::s_transition_postgresql_base
#
# Base node for s_transition_postgresql_{master,slave}
#
class govuk::node::s_transition_postgresql_base (
  $env_sync_access_key_id = undef,
  $env_sync_secret_access_key = undef,
  $env_sync_s3_bucket_url = undef,
  $env_sync_private_gpg_key = undef,
  $env_sync_private_gpg_key_fingerprint = undef,
  $env_sync_private_gpg_key_passphrase = undef,
  $env_sync_enabled = false,
) inherits govuk::node::s_base {
  include govuk::apps::transition::postgresql_db

  Govuk_mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server']

  include govuk_postgresql::tuning

  postgresql::server::config_entry { 'random_page_cost':
    value => 2.5,
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
}
