# == Define: monitoring::checks::cache_config
#
# Nagios alert config for AWS Elastic Cache.
#
# === Parameters
#
# [*region*]
#   Which AWS region should be checked ['us-east-1','eu-west-1']
#
# [*enabled*]
#   Should we enable the monitoring check?
#
# [*cpu_warning*]
#  This parameter defines the CPU usage percentage at which a warning is raised. 
#
# [*critical*]
#  This parameter defines the CPU usage percentage at which a critcal alert is raised.
#
# [*memory_warning]
#  This parameter defines the amount of free memory in Gigabytes for which a warning alert will be raised.
#
# [*memory_critical]
#  This parameter defines the amount of free memory in Gigabytes for which a critical alert will be raised. 
#
define monitoring::checks::cache_config (
  $region = undef,
  $cpu_warning = 80,
  $cpu_critical = 90,
  $memory_warning = 20,
  $memory_critical = 10,
  ){
  icinga::check { "check_aws_cache_cpu-${title}":
    check_command       => "check_aws_cache_cpu!${region}!${cpu_warning}!${cpu_critical}!${::aws_stackname}-${title}",
    host_name           => $::fqdn,
    service_description => "${title} - AWS ElastiCache CPU Utilization",
    notes_url           => monitoring_docs_url(aws-cache-cpu),
    require             => Icinga::Check_config['check_aws_cache_cpu'],
  }

  icinga::check { "check_aws_cache_memory-${title}":
    check_command       => "check_aws_cache_memory!${region}!${memory_warning}!${memory_critical}!${::aws_stackname}-${title}",
    host_name           => $::fqdn,
    service_description => "${title} - AWS ElastiCache Memory Utilization",
    notes_url           => monitoring_docs_url(aws-cache-memory),
    require             => Icinga::Check_config['check_aws_cache_memory'],
  }
}
