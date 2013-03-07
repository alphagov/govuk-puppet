define govuk::logstream (
  $logfile,
  $tags = [],
  $enable = false
) {

  if $enable == true {
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
      require => Service["logstream-${title}"],
    }

    service { "logstream-${title}":
      ensure   => stopped,
      provider => 'upstart',
    }
  }

}
