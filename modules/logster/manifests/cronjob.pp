define logster::cronjob (
  $file,
  $parser = 'ExtendedSampleLogster',
  $prefix = ''
) {

  $prefix_real = $prefix ? {
    ''      => '',
    default => "--metric-prefix=${prefix} ",
  }

  $fqdn_escaped = regsubst($::fqdn, '\.', '_', 'G')
  $output = "--output=ganglia --output=graphite --graphite-host=graphite.cluster:2003 --graphite-prefix=${fqdn_escaped}"
  $args = "${prefix_real}${output} ${parser} ${file}"

  cron { "logster-cronjob-${title}":
    command => "/usr/sbin/logster ${args}",
    user    => root,
    minute  => '*/2',
    require => File['/usr/sbin/logster'],
  }

}
