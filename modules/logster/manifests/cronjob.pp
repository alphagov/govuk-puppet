define logster::cronjob (
  $file,
  $parser = 'ExtendedSampleLogster',
  $prefix = ''
) {

  $prefix_real = $prefix ? {
    ''      => $::fqdn_underscore,
    default => "${::fqdn_underscore}.${prefix}",
  }

  $output = "--output=graphite --graphite-host=graphite.cluster:2003"
  $args = "--metric-prefix=${prefix_real} ${output} ${parser} ${file}"

  cron { "logster-cronjob-${title}":
    command => "/usr/sbin/logster ${args}",
    user    => root,
    minute  => '*/2',
    require => File['/usr/sbin/logster'],
  }

}
