define govuk::logstream (
  $logfile,
  $tags = [],
  $fields = {},
  $enable = false,
  $host = $::fqdn
) {

  if ($enable == true and $::govuk_platform != 'development') {
    $tag_string = join($tags, ' ')

    file { "/etc/init/logstream-${title}.conf":
      ensure  => present,
      content => template('govuk/logstream.erb'),
      notify  => Service["logstream-${title}"],
      }

    service { "logstream-${title}":
      ensure    => running,
      provider  => 'upstart',
    }
  } else {

    file { "/etc/init/logstream-${title}.conf":
      ensure  => absent,
      require => Exec["logstream-STOP-${title}"],
    }

    exec { "logstream-STOP-${title}" :
      command => "initctl stop logstream-${title}",
      onlyif  => "initctl status logstream-${title}",
    }
  }

}
