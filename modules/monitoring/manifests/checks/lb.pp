# == Class: monitoring::checks::lb
#
# Nagios alerts for AWS LoadBalancers.
#
# === Parameters
#
# [*region*]
#   Which AWS region should be checked ['us-east-1','eu-west-1','eu-west-2']
#
# [*loadbalancers*]
#   Hash of LoadBalancers (ALB/ELB)
#
# [*enabled*]
#   This variable enables to define whether to perform Icinga LB checks.
#
class monitoring::checks::lb (
      $enabled = true,
      $loadbalancers = {},
      $region = undef,
    ) {

    icinga::plugin { 'check_aws_lb_healthyhosts':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_lb_healthyhosts',
        require => Exec['install_boto3'],
    }

    icinga::check_config { 'check_aws_lb_healthyhosts':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_lb_healthyhosts.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_lb_healthyhosts'],
    }

    if $enabled {
        create_resources('monitoring::checks::lb_config', $loadbalancers, {
            'region' => $region,
        })
    }
}
