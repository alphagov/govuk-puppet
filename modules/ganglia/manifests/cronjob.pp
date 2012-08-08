define ganglia::cronjob (
  $content = undef,
  $source = undef,
  $user = 'root',
  $minute = '*'
) {

  file { "/etc/ganglia/scripts/${title}":
    ensure  => present,
    content => $content,
    source  => $source,
    mode    => '0755',
  }

  cron { "ganglia-${title}":
    user    => $user,
    minute  => $minute,
    command => "/etc/ganglia/scripts/${title}",
    require => File["/etc/ganglia/scripts/${title}"],
  }

}
