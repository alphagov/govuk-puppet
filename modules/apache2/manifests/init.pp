File {
  owner => 'root',
  group => 'root',
  mode  => '644',
}

class apache2 {
  define a2ensite() {
    exec { "a2ensite $name":
      command => "/usr/sbin/a2ensite $name",
      unless => "/bin/sh -c '[ -L /etc/apache2/sites-enabled/$name ] \\
        && [ /etc/apache2/sites-enabled/$name -ef /etc/apache2/sites-available/$name ]'",
      require => [
        Class["apache2::service"],
        File["/etc/apache2/sites-available/$name"]
      ],
      notify => Exec["apache_graceful"]
    }
  }


  define a2enmod() {
    exec { "a2enmod $name":
      command => "/usr/sbin/a2enmod $name",
      unless  => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/$name.load ] \\
        && [ /etc/apache2/mods-enabled/$name.load -ef /etc/apache2/mods-available/$name.load ]'",
      require => Package["apache2"],
      notify  => Exec["apache_graceful"],
    }
  }

  define a2dismod() {
    exec { "a2dismod $name":
      command => "/usr/sbin/a2dismod $name",
      onlyif  => "/bin/readlink -e /etc/apache2/mods-enabled/$name.load",
      require => Package["apache2"],
      notify  => Exec["apache_graceful"],
    }
  }

  exec { "apache_graceful":
    command     => "apache2ctl graceful",
    refreshonly => true,
    onlyif      => "apache2ctl configtest",
  }

  include apache2::install
  include apache2::configure
  include apache2::service
}

class apache2::install {
  package { "apache2":
    ensure => installed,
  }

  a2enmod { "headers": }
  a2dismod { "status": }
}

class apache2::configure {

  file { "/etc/apache2/sites-available/default":
    ensure  => 'present',
    source  => 'puppet:///modules/apache2/000-default',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { "/etc/apache2/conf.d/localized-error-pages":
    ensure  => present,
    source  => 'puppet:///modules/apache2/localized-error-pages',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { "/etc/apache2/apache2.conf":
    ensure  => present,
    source  => 'puppet:///modules/apache2/apache2.conf',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { "/etc/apache2/envvars":
    ensure  => present,
    source  => 'puppet:///modules/apache2/envvars',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { "/etc/apache2/ports.conf":
    ensure  => present,
    content => template('apache2/ports.conf'),
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { "/etc/apache2/conf.d/security":
    ensure  => present,
    source  => 'puppet:///modules/apache2/security',
    require => Class['apache2::install'],
    notify  => Service['apache2'],
  }

  file { "/data/vhost":
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '755',
    require => User['deploy'],
  }
}

class apache2::service {
  service { "apache2":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Class["apache2::configure"]
  }
}

class apache2::vhost {
  include logster
  include graylogtail

  define passenger($aliases = [], $environment = "production", $additional_port = false) {
    file { "/etc/apache2/sites-available/$name":
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template('apache2/passenger-vhost.conf'),
      notify  => Service["apache2"],
      require => Class["apache2::install"]
    }

    @@nagios_service { "check_apache_5xx_${name}_on_${hostname}":
      use           => "generic-service",
      check_command => "check_ganglia_metric!${name}_apache_http_5xx!0.05!0.1",
      service_description => "check apache error rate for ${name}",
      host_name     => "${govuk_class}-${hostname}",
      target        => "/etc/nagios3/conf.d/nagios_service.cfg",
    }

    cron { "logster-apache-$name":
      command => "/usr/sbin/logster --metric-prefix $name ApacheGangliaLogster /var/log/apache2/${name}-access_log",
      user    => root,
      minute  => '*/2'
    }

    graylogtail::collect { "graylogtail-rails-$name":
      log_file => "/data/vhost/${name}/shared/log/production.log",
      facility => $name,
    }
    graylogtail::collect { "graylogtail-apache-access-$name":
      log_file => "/var/log/apache2/${name}-access_log",
      facility => $name,
    }
    graylogtail::collect { "graylogtail-apache-errors-$name":
      log_file => "/var/log/apache2/${name}-error_log",
      facility => $name,
      level    => "error",
    }

    a2ensite { $name: }
  }

  define static() {
    file { "/etc/apache2/sites-available/$name":
      owner => "root",
      group => "root",
      mode => 0644,
      content => template('apache2/static-vhost.conf'),
      notify  => Service["apache2"],
      require => Class["apache2::install"]
    }

    a2ensite { $name: }
  }
}
