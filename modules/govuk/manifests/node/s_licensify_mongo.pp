class govuk::node::s_licensify_mongo inherits govuk::node::s_base {
  include ecryptfs
  include mongodb::server
  include java::openjdk6::jre

  govuk::mount { '/mnt/encrypted':
    mountoptions => 'defaults',
    disk         => '/dev/mapper/encrypted-mongodb',
  }

  govuk::mount { '/var/lib/automongodbbackup':
    mountoptions => 'defaults',
    disk         => extlookup('mongodb_backup_disk'),
  }

  # Actual low disk space would get caught by the /mnt/encrypted check however this will catch it not being mounted.
  @@icinga::check { "check_var_lib_mongodb_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /var/lib/mongodb',
    service_description => 'low available disk space on /var/lib/mongodb',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
    }

  $internal_tld = extlookup('internal_tld', 'production')

  $mongo_hosts = [
    "licensify-mongo-1.licensify.${internal_tld}",
    "licensify-mongo-2.licensify.${internal_tld}",
    "licensify-mongo-3.licensify.${internal_tld}"
  ]

  $mongodb_encrypted = str2bool(extlookup('licensify_mongo_encrypted', 'no'))
  if $mongodb_encrypted {
    motd::snippet {'01-encrypted-licensify': }
  }

  # Disable monthly backups to limit the retention of IL3 data.
  class { 'mongodb::backup':
    domonthly => false
  }

  class { 'mongodb::configure_replica_set':
    members => $mongo_hosts
  }
}
