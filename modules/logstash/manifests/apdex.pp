define logstash::apdex(
  $instance_class = undef
){
  cron { "apdex-for-${title}":
    command => "/usr/local/bin/apdex.sh ${instance_class} ${title}",
    user    => 'logstash',
    minute  => '30',
  }
}
