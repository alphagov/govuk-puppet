class govuk::node::s_licensify_mongo inherits govuk::node::s_base {
  include ecryptfs
  include mongodb::server
  include java::openjdk6::jre

  ext4mount { '/mnt/encrypted':
    mountoptions => 'defaults',
    disk         => '/dev/mapper/encrypted-mongodb',
  }

  @@nagios::check { "check_mnt_encrypted_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /mnt/encrypted',
    service_description => 'low available disk space on /mnt/encrypted',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
  }

  @@nagios::check { "check_mnt_encrypted_disk_inodes_${::hostname}":
    check_command       => 'check_nrpe!check_disk_inodes_arg!20% 10% /mnt/encrypted',
    service_description => 'low available disk inodes on /mnt/encrypted',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-inodes',
  }

  @@nagios::check { "check_var_lib_automongodbbackup_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /var/lib/automongodbbackup',
    service_description => 'low available disk space on /var/lib/automongodbbackup',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
  }

  @@nagios::check { "check_var_lib_automongodbbackup_disk_inodes_${::hostname}":
    check_command       => 'check_nrpe!check_disk_inodes_arg!20% 10% /var/lib/automongodbbackup',
    service_description => 'low available disk inodes on /var/lib/automongodbbackup',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-inodes',
  }

  # Actual low disk space would get caught by the /mnt/encrypted check however this will catch it not being mounted.
  @@nagios::check { "check_var_lib_mongodb_disk_space_${::hostname}":
    check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /var/lib/mongodb',
    service_description => 'low available disk space on /var/lib/mongodb',
    use                 => 'govuk_high_priority',
    host_name           => $::fqdn,
    document_url        => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
  }

  $internal_tld = extlookup('internal_tld', 'production')

  case $::govuk_provider {
    sky: {
      $mongo_hosts = [
        "licensify-mongo-1.licensify.${internal_tld}",
        "licensify-mongo-2.licensify.${internal_tld}",
        "licensify-mongo-3.licensify.${internal_tld}"
      ]
    }
    #aws
    default: {
      $mongo_hosts = [
        'licensify-mongo0',
        'licensify-mongo1',
        'licensify-mongo2'
      ]
    }
  }

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
