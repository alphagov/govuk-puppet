class puppetdb::config {

  $puppetdb_postgres_password = extlookup('puppetdb_postgres_password', '')

  # This caters for Amazon Preview where puppetmaster is a small instance
  # When Amazon is dead, we should just make this 1024
  if $::govuk_provider == 'sky' {
    $java_args = '-Xmx1024m'
  } else {
    $java_args = $::govuk_platform ? {
      'production'   => '-Xmx1024m',
      default        => '-Xmx192m',
    }
  }

  # By default, this script should be run by apt-get install. But if, for
  # whatever reason, it fails on first run, or someone accidentally removes
  # the keystore, this should ensure that it is recreated, and the appropriate
  # config file in /etc/puppetdb/conf.d updated.
  exec { '/usr/sbin/puppetdb-ssl-setup':
    creates => '/etc/puppetdb/ssl/keystore.jks',
  }

  # This kills off the SysV puppetdb script.
  exec { 'disable-default-puppetdb':
    command => '/etc/init.d/puppetdb stop && /bin/rm /etc/init.d/puppetdb && /usr/sbin/update-rc.d puppetdb remove',
    unless  => '/usr/bin/test ! -e /etc/init.d/puppetdb',
  }

  # We manage database.ini, puppetdb.ini, and repl.ini
  #
  # A fourth file, jetty.ini, is installed by the package, and should be left
  # alone. Its contents will be modified by the puppetdb-ssl-setup script above.
  file { '/etc/puppetdb/conf.d/database.ini':
    ensure  => 'present',
    content => template('puppetdb/database.ini.erb'),
  }

  file { '/etc/puppetdb/conf.d/puppetdb.ini':
    ensure => 'present',
    source => 'puppet:///modules/puppetdb/puppetdb.ini',
  }

  file { '/etc/puppetdb/conf.d/repl.ini':
    ensure => 'present',
    source => 'puppet:///modules/puppetdb/repl.ini',
  }

  file { '/etc/init/puppetdb.conf':
    ensure  => 'present',
    content => template('puppetdb/upstart.conf.erb'),
  }

  postgres::user { 'puppetdb':
    password => $puppetdb_postgres_password,
  }

  postgres::database { 'puppetdb':
    owner => 'puppetdb',
  }

  @logrotate::conf { 'puppetdb':
    matches => '/var/log/puppetdb/*.log',
  }

}
