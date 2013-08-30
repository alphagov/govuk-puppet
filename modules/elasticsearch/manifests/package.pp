class elasticsearch::package (
  $version = undef,
) {

  if $version == undef {
    fail('You must provide an elasticsearch version for package installation')
  }

  package { 'elasticsearch':
    ensure  => $version,
    notify  => Exec['disable-default-elasticsearch'],
    require => Class['java::set_defaults'],
  }

  # Disable the default elasticsearch setup, as we'll be installing an upstart
  # job to manage elasticsearch in elasticsearch::{config,service}
  exec { 'disable-default-elasticsearch':
    onlyif      => '/usr/bin/test -f /etc/init.d/elasticsearch',
    command     => '/etc/init.d/elasticsearch stop && /bin/rm -f /etc/init.d/elasticsearch && /usr/sbin/update-rc.d elasticsearch remove',
    refreshonly => true,
  }

  # Manage elasticsearch plugins, which are installed by elasticsearch::plugin
  file { '/usr/share/elasticsearch/plugins':
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
    require => Package['elasticsearch'],
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

  # Install the estools package (which we maintain, see
  # https://github.com/alphagov/estools), which is used to install templates
  # and rivers, among other things.
  package { 'estools':
    ensure   => '1.1.0',
    provider => 'pip',
  }

}
