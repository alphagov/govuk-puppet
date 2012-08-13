define logster::cronjob (
  $args
) {

  cron { "logster-cronjob-${title}":
    command => "/usr/sbin/logster ${args}",
    user    => root,
    minute  => '*/2',
    require => File['/usr/sbin/logster'],
  }

}
