# == Class: monitoring::checks::cache
#
# Nagios alerts for AWS Elastic Cache.
#
# === Parameters
#
# [*enabled*]
#   This variable enables to define whether to perform Icinga Elastic-Cache checks. [This is set to 'true' by default.]
#
# [*servers*]
#   List of RDS instances.
#
# [*region*]
#   Which AWS region should be checked ['us-east-1','eu-west-1']
#
class monitoring::checks::cache (
      $enabled = true,
      $servers = [],
      $region = undef,
    ) {

    icinga::plugin { 'check_aws_cache_cpu':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_cache_cpu',
        require => Exec['install_boto'],
    }

    icinga::check_config { 'check_aws_cache_cpu':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_cache_cpu.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_cache_cpu'],
    }

    icinga::plugin { 'check_aws_cache_memory':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_cache_memory',
        require => Exec['install_boto'],
    }

    icinga::check_config { 'check_aws_cache_memory':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_cache_memory.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_cache_memory'],
    }

    if $enabled {
      monitoring::checks::cache_config { $servers:
        region => $region,
      }
    }
}
