define logster::cronjob (
  $args,
  $output = 'ganglia'
) {

  cron { "logster-cronjob-${title}":
    command => "/usr/sbin/logster --output=${output} ${args}",
    user    => root,
    minute  => '*/2',
    require => File['/usr/sbin/logster'],
  }

}
