define govuk::app( $port, $platform = $::govuk_platform, $config = false, $vhost = 'NOTSET' ) {

  # In the development environment, assume the repos are checked out straight
  # into /var/govuk.
  if $platform == 'development' {
    file { "/var/apps/${title}":
      ensure => link,
      target => "/var/govuk/${title}";
    }

  # Otherwise, we're talking about a deployment environment. Cap should deploy
  # to /var/govuk/APPNAME/release_XXX and symlink from
  # /var/govuk/APPNAME/current
  } else {
    file { "/var/apps/${title}":
      ensure => link,
      target => "/var/govuk/${title}/current";
    }
    file { "/var/govuk/${title}":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy';
    }
  }


  file { "/etc/envmgr/${title}.conf":
    ensure => 'file',
    source => $config ? {
      true    => "puppet:///modules/govuk/etc/envmgr/${title}.conf",
      default => undef,
    },
    content => $config ? {
      true    => undef,
      default => '',
    };
  }


  file { "/var/run/${title}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  file { "/etc/init/${title}.conf":
    content => template('govuk/app_upstart.conf.erb');
  }

  service { "${title}":
    ensure    => running,
    provider  => upstart,
    require   => [
      Class["govuk::deploy_tools"],
      File["/etc/envmgr/${title}.conf"],
      File["/etc/init/${title}.conf"],
      File["/var/run/${title}"],
      File["/var/apps/${title}"]
    ],
    subscribe => File["/etc/init/${title}.conf"];
  }

  $app_vhost = $vhost ? {
    'NOTSET' => "${title}",
    default  => "${vhost}",
  }

  if $::govuk_platform == 'development' {
    nginx::config::vhost::dev_proxy { "${app_vhost}.dev.gov.uk":
      to => ["localhost:${port}"];
    }
  } else {
    nginx::config::vhost::proxy { "${app_vhost}.${platform}.alphagov.co.uk":
      to => ["localhost:${port}"];
    }
  }

}
