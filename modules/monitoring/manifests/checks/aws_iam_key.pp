# == Class: monitoring::checks::aws_iam_key
#
# Single Nagios alert for iam key rotations being required in the environment
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
class monitoring::checks::aws_iam_key (
  $region = undef,
  $access_key = undef,
  $secret_key = undef,
  $enabled = true,
) {
  if $enabled and $::aws_migration {
    $max_age = 90

    icinga::plugin { 'check_aws_iam_key_age':
      source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_iam_key_age',
    }

    icinga::check_config { 'check_aws_iam_key_age':
      content => template('monitoring/check_aws_iam_key_age.cfg.erb'),
      require => File['/usr/lib/nagios/plugins/check_aws_iam_key_age'],
    }

    icinga::check { 'check_aws_iam_key_age':
      check_command       => 'check_aws_iam_key_age',
      use                 => 'govuk_normal_priority',
      host_name           => $::fqdn,
      check_interval      => 43200,
      service_description => 'At least 1 AWS IAM Key is older then max_age days and needs rotating',
      notes_url           => monitoring_docs_url(rotate-old-aws-iam-key),
      require             => Icinga::Check_config['check_aws_iam_key_age'],
    }
  }
}
