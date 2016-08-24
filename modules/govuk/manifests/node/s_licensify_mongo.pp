# == Class: govuk::node::s_licensify_mongo
#
# licensify mongo node
#
# === Parameters
#
# [*licensify_mongo_encrypted*]
#   If true, MongoDB data will be stored on a partition that is encrypted at rest.
#
class govuk::node::s_licensify_mongo (
  $licensify_mongo_encrypted = false
) inherits govuk::node::s_base {
  include mongodb::server

  # FIXME: Remove once deployed
  package { 'openjdk-6-jre-headless':
    ensure => absent,
  }

  if $licensify_mongo_encrypted {
    include ecryptfs
    motd::snippet {'01-encrypted-licensify': }
    Govuk_mount['/mnt/encrypted'] -> Class['mongodb::server']

    # Actual low disk space would get caught by the /mnt/encrypted check however this will catch it not being mounted.
    # Only check if MongoDB's data is on an encrypted filesystem; otherwise /var/lib/mongodb is not used as a mountpoint.
    @@icinga::check { "check_var_lib_mongodb_disk_space_${::hostname}":
      check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /var/lib/mongodb',
      service_description => 'low available disk space on /var/lib/mongodb',
      use                 => 'govuk_high_priority',
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(low-available-disk-space),
    }
  }

  Govuk_mount['/var/lib/automongodbbackup'] -> Class['mongodb::backup']
}
