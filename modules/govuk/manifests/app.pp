define govuk::app(
  $type,
  $port,
  $platform = $::govuk_platform,
  $environ_content = 'NOTSET',
  $environ_source = 'NOTSET',
  $vhost = 'NOTSET',
  $vhost_aliases = [],
  $vhost_protected = true,
  $vhost_ssl_only = false,
  $nginx_extra_config = ''
) {

  if ! ($type in ['procfile', 'rack', 'rails']) {
    fail 'Invalid argument $type to govuk::app! Must be one of "procfile", "rack", or "rails".'
  }

  if $environ_content != 'NOTSET' and $environ_source != 'NOTSET' {
    fail 'You may only set one of $environ_content and $environ_source in govuk::app'
  }

  $vhost_real = $vhost ? {
    'NOTSET' => $title,
    default  => $vhost,
  }

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

  $vhost_full = "${vhost_real}.${domain}"

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
      target => "/data/vhost/${vhost_full}/current";
    }
    file { "/data/vhost/${vhost_full}":
      ensure => directory,
      owner  => 'deploy',
      group  => 'deploy';
    }
  }

  # Install environment/configuration file
  file { "/etc/envmgr/${title}.conf":
    ensure  => 'file',
  }

  if $environ_content != 'NOTSET' {
    File["/etc/envmgr/${title}.conf"] {
      content => $environ_content
    }
  } elsif $environ_source != 'NOTSET' {
    File["/etc/envmgr/${title}.conf"] {
      source => $environ_source
    }
  } else {
    File["/etc/envmgr/${title}.conf"] {
      content => ''
    }
  }

  # Make sure run directory exists
  file { "/var/run/${title}":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  # Install service
  file { "/etc/init/${title}.conf":
    content => template('govuk/app_upstart.conf.erb');
  }

  service { $title:
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

  if $platform != 'development' {
    Service[$title] {
      ensure => running
    }
  }

  $vhost_aliases_real = regsubst($vhost_aliases, '^.+$', "\\0.${domain}")

  # Expose this application from nginx
  if $platform == 'development' {
    nginx::config::vhost::dev_proxy { $vhost_full:
      to           => ["localhost:${port}"],
      aliases      => $vhost_aliases_real,
      extra_config => $nginx_extra_config,
    }
  } else {
    nginx::config::vhost::proxy { $vhost_full:
      to           => ["localhost:${port}"],
      aliases      => $vhost_aliases_real,
      protected    => $vhost_protected,
      ssl_only     => $vhost_ssl_only,
      extra_config => $nginx_extra_config,
    }
  }

  # Set up monitoring
  if $platform != 'development' {
    govuk::app::monitoring { $title: }
  }

}

define govuk::app::monitoring {

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

}
