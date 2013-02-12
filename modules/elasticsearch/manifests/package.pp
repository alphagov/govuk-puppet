class elasticsearch::package {

  package { 'elasticsearch':
    ensure => '0.19.8',
    notify => Exec['disable-default-elasticsearch'],
  }

  # Disable the default elasticsearch setup, as we'll be installing an upstart
  # job to manage elasticsearch in elasticsearch::{config,service}
  exec { 'disable-default-elasticsearch':
    command     => '/etc/init.d/elasticsearch stop && /bin/rm /etc/init.d/elasticsearch && /usr/sbin/update-rc.d elasticsearch remove',
    refreshonly => true,
  }

  # Manage elasticsearch plugins, which are installed by elasticsearch::plugin
  file { '/usr/share/elasticsearch/plugins':
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
  }

  file { '/var/run/elasticsearch':
    ensure => directory,
  }

  file { '/var/log/elasticsearch':
    ensure  => directory,
    owner   => 'elasticsearch',
    group   => 'elasticsearch',
    require => Package['elasticsearch'], # need to wait for package to create ES user.
  }

}
