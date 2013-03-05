define govuk::app::service ( $logstream = false ) {

  $enable_service = str2bool(extlookup('govuk_app_enable_services', 'yes'))

  service { $title:
    provider => 'upstart',
  }

  if $enable_service {
    Service[$title] {
      ensure => running
    }
  }

  if $logstream {

    govuk::app::logstream { "${title}-upstart-out":
        logfile => "/var/log/${title}/upstart.out.log",
        tags    => [$title, 'STDOUT', 'UPSTART'],
    }

    govuk::app::logstream { "${title}-upstart-err":
      logfile => "/var/log/${title}/upstart.err.log",
      tags    => [$title, 'STDERR', 'UPSTART'],
    }

  }

}
