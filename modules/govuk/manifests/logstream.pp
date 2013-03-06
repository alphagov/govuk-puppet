define govuk::logstream (
  $logfile,
  $tags = []
) {

  $tag_string = join($tags, ' ')

  file { "/etc/init/logstream-${title}.conf":
    ensure  => present,
    content => template('govuk/logstream.erb'),
    notify  => Service["logstream-${title}"]
  }

  service { "logstream-${title}":
    ensure    => running,
    provider  => 'upstart',
  }

}
