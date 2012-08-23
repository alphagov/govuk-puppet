define govuk::app(
  #
  # app_type: 'rack' or 'procfile'.
  #
  # An app_type of 'rack' will assume the presence of a `config.ru` file in
  # the root of the deployed application, and will run the rack up under
  # unicorn.
  #
  # An app_type of 'procfile' will assume the presence of a `Procfile` in the
  # root of the deployed application, which defines a 'web' process type.
  #
  $app_type,

  #
  # port: internal HTTP port for the application.
  #
  # If the `app_type` is rack, the -P option will be passed to unicorn
  # automatically. If the `app_type` is 'procfile', then the command run by
  # the Procfile MUST listen on the port defined by the 'PORT' environment
  # variable.
  #
  $port,

  #
  # platform: the deployment environment to configure
  #
  # You probably don't need to set this explicitly.
  #
  $platform = $::govuk_platform,

  #
  # environ_content: contents of the envmgr config file loaded for this app
  #
  # This can be used to define the contents of an
  # [envmgr](https://github.com/nickstenning/envmgr) config file which is
  # loaded before your application. This file can be used to control the
  # environment variables available to the application:
  #
  #     govuk::app { 'foo':
  #       [...]
  #       environ_content => "SECRET_KEY=2DD6A5F73278",
  #     }
  #
  #     govuk::app { 'foo':
  #       [...]
  #       environ_content => template('govuk/apps/foo_environment.conf'),
  #     }
  #
  $environ_content = 'NOTSET',

  #
  # environ_source: source of the envmgr config file loaded for this app
  #
  # Same as environ_content but using Puppet's `source` parameter.
  #
  $environ_source = 'NOTSET',

  #
  # vhost: the virtual host prefix for this app
  #
  # Defaults to $title, the name of your application.
  #
  # The app will be served at "$vhost.$platform.alphagov.co.uk" in production
  # and preview environments.
  #
  $vhost = 'NOTSET',

  #
  # vhost_aliases: other vhosts on which your app is served
  #
  # Use of this parameter is discouraged: there should preferably be one and
  # only one home for your application. Moreover, all apps are served from a
  # common namespace, and the more names an app has, the greater the chances
  # of a namespace collision.
  #
  $vhost_aliases = [],

  #
  # vhost_protected: should this vhost be protected with HTTP Basic auth?
  #
  # Boolean: true or false
  #
  $vhost_protected = true,

  #
  # vhost_ssl_only: should this app be served exclusively over HTTPS
  #
  # Boolean: true or false
  #
  $vhost_ssl_only = false,

  #
  # nginx_extra_config: additional nginx configuration for this app
  #
  # This parameter can be used to supply additional nginx configuration
  # directives to be included in your application. In general, use of this
  # parameter indicates that your app is doing something "special", and we
  # should be striving for an infrastructure that contains the smallest
  # possible number of "special cases". As such, use of this option is
  # discouraged, and it is included for backwards compatibility purposes only.
  #
  $nginx_extra_config = ''
) {

  if ! ($app_type in ['procfile', 'rack']) {
    fail 'Invalid argument $app_type to govuk::app! Must be one of "procfile" or "rack".'
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

  file { ["/var/log/${title}", "/var/run/${title}"]:
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy';
  }

  file { ["/var/log/${title}/app.out.log", "/var/log/${title}/app.err.log"]:
    ensure => file,
    owner  => 'deploy',
    group  => 'deploy';
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

  # Install service
  file { "/etc/init/${title}.conf":
    content => template('govuk/app_upstart.conf.erb');
  }

  service { $title:
    provider  => upstart,
    require   => [
      Class['govuk::deploy'],
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
  nginx::config::vhost::proxy { $vhost_full:
    to           => ["localhost:${port}"],
    aliases      => $vhost_aliases_real,
    protected    => $vhost_protected,
    ssl_only     => $vhost_ssl_only,
    extra_config => $nginx_extra_config,
    platform     => $platform,
  }

  # Set up monitoring
  if $platform != 'development' {
    file { "/usr/lib/ganglia/python_modules/app-${title}-procstat.py":
      ensure  => link,
      target  => '/usr/lib/ganglia/python_modules/procstat.py',
      require => Ganglia::Pymod['procstat'],
    }
  }

  @ganglia::pyconf { "app-${title}":
    content => template('govuk/etc/ganglia/conf.d/procstat.pyconf.erb'),
    require => File["/usr/lib/ganglia/python_modules/app-${title}-procstat.py"],
  }

  @logstash::collector { "app-${title}":
    content => template('govuk/app_logstash.conf.erb'),
  }

  @logrotate::conf { "govuk-${title}":
    matches => "/var/log/${title}/*.log",
  }

  @logrotate::conf { "govuk-${title}-rack":
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
  }

  @@nagios::check { "check_${title}_app_cpu_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_cpu!50!100",
    service_description => "Check CPU used by app ${title} is not too high",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  @@nagios::check { "check_${title}_app_mem_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_mem!1000000000!2000000000",
    service_description => "Check memory used by app ${title} is not too high",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
