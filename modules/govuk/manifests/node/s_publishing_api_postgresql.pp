# == Class: govuk::node::s_publishing_api_postgresql
#
# PostgreSQL node for the Data publishing_api.
#
class govuk::node::s_publishing_api_postgresql (
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_url,
  $wale_private_gpg_key,
  $wale_private_gpg_key_fingerprint,
  $alert_hostname = 'alert.cluster',
) inherits govuk::node::s_base  {
  include govuk_env_sync
  Govuk_mount['/var/lib/postgresql'] -> Class['govuk_postgresql::server::standalone']

  include govuk_postgresql::server::standalone
  include govuk_postgresql::tuning

  govuk_postgresql::wal_e::backup { $title:
    aws_access_key_id                => $aws_access_key_id,
    aws_secret_access_key            => $aws_secret_access_key,
    s3_bucket_url                    => $s3_bucket_url,
    wale_private_gpg_key             => $wale_private_gpg_key,
    wale_private_gpg_key_fingerprint => $wale_private_gpg_key_fingerprint,
    alert_hostname                   => $alert_hostname,
  }
}
