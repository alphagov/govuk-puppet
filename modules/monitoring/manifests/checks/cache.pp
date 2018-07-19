# == Class: monitoring::checks::cache
#
# Nagios alerts for AWS Elastic Cache.
#
# === Parameters
#
# [*servers*]
#   List of RDS instances.
#
class monitoring::checks::cache (
      $enabled = true,
      $servers = [],
    ) {

    icinga::plugin { 'check_aws_cache_cpu':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_cache_cpu',
        require => Package['boto'],
    }

    icinga::check_config { 'check_aws_cache_cpu':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_cache_cpu.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_cache_cpu'],
    }

    icinga::plugin { 'check_aws_cache_memory':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_cache_memory',
        require => Package['boto'],
    }

    icinga::check_config { 'check_aws_cache_memory':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_cache_memory.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_cache_memory'],
    }

    if $enabled {
      monitoring::checks::cache_config { $servers: }
    }
}
