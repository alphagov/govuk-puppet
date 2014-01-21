# == Class: monitoring::checks::ses
#
# Nagios alerts for SES quota limits.
#
# === Variables:
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
# [*enable*]
#   Should we enable the Nagios check? Default:false
#
# [*warning*]
#   What percentage usage should trigger a warning? Default:30
#
# [*critical*]
#   What percentage usage should trigger a critical? Default:50
#
class monitoring::checks::ses (
        $region,
        $access_key,
        $secret_key,
        $enable  = false,
        $warning = 30,
        $critical = 50 ){

    package {'python-boto':
        ensure => present,
    }

    file{'/usr/lib/nagios/plugins/check_aws_quota':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_quota',
        require => Package['python-boto']
    }

    file{'/etc/nagios3/conf.d/check_aws_quota.cfg':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_aws_quota.cfg',
        require => File['/usr/lib/nagios/plugins/check_aws_quota'],
    }

    if str2bool($enable) {

        nagios::check { 'check_aws_quota':
            check_command       => "check_aws_quota!${region}!${access_key}!${secret_key}!${warning}!${critical}",
            use                 => 'govuk_urgent_priority',
            host_name           => $::fqdn,
            service_description => 'Check we are not exceeding our AWS SES email quota',
            require             => File['/etc/nagios3/conf.d/check_aws_quota.cfg']
        }

    }

}
