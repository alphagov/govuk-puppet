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
  if $enabled {
    icinga::plugin { 'check_aws_quota':
      source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_quota',
      require => Exec['install_boto'],
    }

    icinga::check_config { 'check_aws_quota':
      content => template('monitoring/check_aws_quota.cfg.erb'),
      require => File['/usr/lib/nagios/plugins/check_aws_quota'],
    }

    icinga::check { 'check_aws_quota':
      check_command       => "check_aws_quota!${region}!${warning}!${critical}",
      use                 => 'govuk_urgent_priority',
      host_name           => $::fqdn,
      service_description => 'AWS SES quota usage higher than expected during last 24hrs',
      notes_url           => monitoring_docs_url(aws-ses-email-quota),
      require             => Icinga::Check_config['check_aws_quota'],
    }
  }
}
