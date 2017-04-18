# == Class: monitoring::checks::ses
#
# Nagios alerts for SES quota limits.
#
# === Parameters
#
# [*region*]
#   Which SES region should be checked ['us-east-1','eu-west-1']
#
# [*access_key*]
#   AWS access key to use
#
# [*secret_key*]
#   AWS secret key to use
#
# [*enabled*]
#   Should we enable the monitoring check?
#
# [*warning*]
#   What percentage usage should trigger a warning? Default:30
#
# [*critical*]
#   What percentage usage should trigger a critical? Default:50
#
class monitoring::checks::ses (
        $region = undef,
        $access_key = undef,
        $secret_key = undef,
        $enabled = true,
        $warning = 30,
        $critical = 50,
    ) {

    package {'boto':
        ensure   => '2.24.0',
        provider => pip,
    }

    file { '/etc/boto.cfg' :
      ensure => present,
      mode   => '0744',
      source => 'puppet:///modules/monitoring/etc/boto.cfg'
    }

    icinga::plugin { 'check_aws_quota':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_quota',
        require => Package['boto'],
    }

    icinga::check_config { 'check_aws_quota':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_quota.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_quota'],
    }

    if $enabled {

        icinga::check { 'check_aws_quota':
            check_command       => "check_aws_quota!${region}!${access_key}!${secret_key}!${warning}!${critical}",
            use                 => 'govuk_urgent_priority',
            host_name           => $::fqdn,
            service_description => 'AWS SES quota usage higher than expected during last 24hrs',
            notes_url           => monitoring_docs_url(aws-ses-email-quota),
            require             => Icinga::Check_config['check_aws_quota'],
        }

    }

}
