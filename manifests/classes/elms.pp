class elms_base::mongo_server {
  include govuk::node::s_base
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

  class { 'mongodb::backup':
    members   => $mongo_hosts,
    domonthly => false
  }

  class { 'mongodb::configure_replica_set':
    members => $mongo_hosts
  }

  $mongodb_encrypted = str2bool(extlookup('licensify_mongo_encrypted', 'no'))
  if $mongodb_encrypted {
    file { '/etc/motd-mongodb-encrypted':
      ensure  => present,
      content => '
          This server has an encrypted drive for /var/lib/mongodb

          After reboot, please see the Operations Manual for how to remount
          the /var/lib/mongodb partition as it requires manual intervention.
      ',
    }
    file { '/etc/motd':
      ensure  => present,
      target  => '/etc/motd-mongodb-encrypted',
      require => File['/etc/motd-mongodb-encrypted'],
    }
  }
}

class elms_base::frontend_server {
  include govuk::node::s_base
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps':
    require => Class['nginx']
  }
}

class elms_base::sky_frontend_server {
  include govuk::node::s_base
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps::licensify': }
}

class elms_base::sky_backend_server {
  include govuk::node::s_base
  include clamav
  include java::openjdk6::jre

  class { 'nginx': }
  class { 'licensify::apps::licensify_admin': }
  class { 'licensify::apps::licensify_feed': }
}
