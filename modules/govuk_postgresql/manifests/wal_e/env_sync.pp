# == Define: Govuk_postgresql::Wal_e::Env_sync
#
# Syncs the database from a specific location from a different environment,
# for example the Production data from an S3 bucket into a Staging environment.
#
# === Parameters:
#
# [*aws_access_key_id*]
#   This is the access key to use to access the bucket that you wish to restore
#   from.
#
# [*aws_secret_access_key*]
#   This is the secret access key associated with the above.
#
# [*s3_bucket_url*]
#   This is the bucket URL for the bucket you wish to restore from. Format is
#   's3://bucket/'
#
# [*wale_private_gpg_key*]
#   The private key is required to decrypt the backups.
#
# [*wale_private_gpg_key_fingerprint*]
#   The fingerprint is required to specify the private key.
#
# [*wale_private_gpg_key_passphrase*]
#   The passphrase for the private key. This is not ideal as it is passed in
#   when decrypting the backups, but is required to do a batch job.
#
# [*aws_region*]
#   The region where the bucket is located.
#
define govuk_postgresql::wal_e::env_sync (
  $aws_access_key_id,
  $aws_secret_access_key,
  $s3_bucket_url,
  $wale_private_gpg_key,
  $wale_private_gpg_key_fingerprint,
  $wale_private_gpg_key_passphrase,
  $aws_region = 'eu-west-1',
) {
    include govuk_postgresql::wal_e::package
    
    $env_sync_envdir = '/etc/wal-e/env_sync/env.d'
    $datadir = $postgresql::params::datadir

    file { [ '/etc/wal-e', '/etc/wal-e/env_sync', $env_sync_envdir ]:
      ensure  => directory,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0775',
      require => Package['wal-e'],
    }

    file { "${env_sync_envdir}/AWS_SECRET_ACCESS_KEY":
      content => $aws_secret_access_key,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { "${env_sync_envdir}/AWS_ACCESS_KEY_ID":
      content => $aws_access_key_id,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { "${env_sync_envdir}/WALE_S3_PREFIX":
      content => $s3_bucket_url,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { "${env_sync_envdir}/AWS_REGION":
      content => $aws_region,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { "${env_sync_envdir}/GPG_PASSPHRASE":
      content => $wale_private_gpg_key_passphrase,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { "${env_sync_envdir}/WALE_GPG_KEY_ID":
      content => $wale_private_gpg_key_fingerprint,
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0640',
    }

    file { "/var/lib/postgresql/.gnupg/${wale_private_gpg_key_fingerprint}_secret_key.asc":
      ensure  => present,
      mode    => '0600',
      content => $wale_private_gpg_key,
      owner   => 'postgres',
      group   => 'postgres',
    }

    exec { "import_gpg_secret_key_for_env_sync_${::hostname}":
      command     => "gpg --batch --delete-secret-and-public-key ${wale_private_gpg_key_fingerprint}; gpg --allow-secret-key-import --import /var/lib/postgresql/.gnupg/${wale_private_gpg_key_fingerprint}_secret_key.asc",
      user        => 'postgres',
      group       => 'postgres',
      subscribe   => File["/var/lib/postgresql/.gnupg/${wale_private_gpg_key_fingerprint}_secret_key.asc"],
      refreshonly => true,
    }

    file { '/usr/local/bin/wal-e_env_sync':
      ensure  => present,
      content => template('govuk_postgresql/usr/local/bin/wal-e_env_sync'),
      mode    => '0755',
      require => Package['wal-e'],
    }

}
