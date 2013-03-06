define logster::cronjob (
  $file,
  $parser = 'ExtendedSampleLogster',
  $prefix = ''
) {

  $prefix_real = $prefix ? {
    ''      => '',
    default => "--metric-prefix=${prefix} ",
  }

  $args = "${prefix_real}${parser} ${file}"

  cron { "logster-cronjob-${title}":
    command => "/usr/sbin/logster --output=ganglia ${args}",
    user    => root,
    minute  => '*/2',
    require => File['/usr/sbin/logster'],
  }

}
