define graphite::cronjob (
  $content = undef,
  $source = undef,
  $user = 'nobody',
  $minute = '*'
) {

  file { "/etc/statsd/scripts/${title}":
    ensure  => present,
    content => $content,
    source  => $source,
    mode    => '0755',
  }

  cron { "statsd-${title}":
    user    => $user,
    minute  => $minute,
    command => "/etc/statsd/scripts/${title}",
    require => File["/etc/statsd/scripts/${title}"],
  }

}
