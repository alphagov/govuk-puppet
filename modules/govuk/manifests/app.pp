define govuk::app(
  $port,
  $platform = $::govuk_platform,
  $config = false,
  $vhost = 'NOTSET',
  $vhost_aliases = [],
  $vhost_protected = true,
  $vhost_ssl_only = false
) {

  $vhost_real = $vhost ? {
    'NOTSET' => ${title},
    default  => ${vhost},
  }

  file { "/var/log/${title}":
    ensure => directory
  }

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
      target => "/data/vhost/${vhost_real}.${platform}.alphagov.co.uk/current";
    }
    file { "/data/vhost/${vhost_real}.${platform}.alphagov.co.uk":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy';
    }
  }

  if $config {
    file { "/etc/envmgr/${title}.conf":
      ensure  => 'file',
      content => template("govuk/etc/envmgr/${title}.conf.erb");
    }
  } else {
    file { "/etc/envmgr/${title}.conf":
      ensure  => 'file',
      content => '';
    }
  }

  file { "/var/run/${title}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  file { "/etc/init/${title}.conf":
    content => template('govuk/app_upstart.conf.erb');
  }

  file { "/usr/lib/ganglia/python_modules/${title}-procstat.py":
    ensure  => link,
    target  => '/usr/lib/ganglia/python_modules/procstat.py',
    require => Class[ganglia::client],
  }

  file {"/etc/ganglia/conf.d/unicorn-${title}.pyconf":
    content => template('govuk/etc/ganglia/conf.d/procstat.pyconf.erb'),
    notify  => Service['ganglia-monitor'],
  }

  file {"/etc/logstash/logstash-client/unicorn-${title}.conf":
    content => template('govuk/etc/logstash/logstash-client/unicorn-logstash.conf.erb'),
    notify  => Class['logstash::client::service']
  }

  @@nagios::check { "check_${title}_unicorn_cpu_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_cpu!50!100",
    service_description => "Check the cpu used by unicorn ${title} isnt too high",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  @@nagios::check { "check_${title}_unicorn_mem_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_mem!100000000!200000000",
    service_description => "Check the mem used by unicorn ${title} isnt too high",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  service { ${title}:
    ensure    => running,
    provider  => upstart,
    require   => [
      Class['govuk::deploy_tools'],
      File["/etc/envmgr/${title}.conf"],
      File["/etc/init/${title}.conf"],
      File["/var/run/${title}"],
      File["/var/apps/${title}"]
    ],
    subscribe => File["/etc/init/${title}.conf"];
  }

  if $platform == 'development' {
    nginx::config::vhost::dev_proxy { "${vhost_real}.dev.gov.uk":
      to => ["localhost:${port}"];
    }
  } else {
    nginx::config::vhost::proxy { "${vhost_real}.${platform}.alphagov.co.uk":
      to        => ["localhost:${port}"],
      aliases   => $vhost_aliases,
      protected => $vhost_protected,
      ssl_only  => $vhost_ssl_only;
    }
  }

}
