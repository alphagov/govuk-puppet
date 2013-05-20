class govuk::node::s_licensify_mongo inherits govuk::node::s_base {
  include ecryptfs
  include mongodb::server
  include java::openjdk6::jre

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
