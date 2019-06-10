# == Class: monitoring::checks::rds
#
# Nagios alerts for AWS RDS.
#
# === Parameters
#
# [*region*]
#   Which AWS region should be checked ['us-east-1','eu-west-1']
#
# [*servers*]
#   List of RDS instances.
#
# [*enabled*]
#   This variable enables to define whether to perform Icinga RDS checks.
#
class monitoring::checks::rds (
      $enabled = true,
      $servers = [],
      $region = undef,
    ) {

    icinga::plugin { 'check_aws_rds_cpu':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_rds_cpu',
        require => Exec['install_boto'],
    }

    icinga::check_config { 'check_aws_rds_cpu':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_rds_cpu.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_rds_cpu'],
    }

    icinga::plugin { 'check_aws_rds_memory':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_rds_memory',
        require => Exec['install_boto'],
    }

    icinga::check_config { 'check_aws_rds_memory':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_rds_memory.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_rds_memory'],
    }

    icinga::plugin { 'check_aws_rds_storage':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_rds_storage',
        require => Exec['install_boto'],
    }

    icinga::check_config { 'check_aws_rds_storage':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_rds_storage.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_rds_storage'],
    }

    if $enabled {
      monitoring::checks::rds_config { $servers:
        region => $region,
      }
      Monitoring::Checks::Rds_config <<| |>>
    }
}
