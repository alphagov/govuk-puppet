define graylogtail::collect(
  $log_file,
  $level = 'info',
  $facility = 'graylogtail',
  $host = 'graylog.cluster'
){
  $stripped_facility = facility_from_host($facility)
  cron { "cron-$name":
    command => "/usr/sbin/graylogtail $log_file --level $level --facility $stripped_facility --graylog-host $host",
    user    => root,
    minute  => '*/2'
  }
}
