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
  $enabled = false,
  $max_aws_iam_key_age = 90,
) {
  if $enabled and $::aws_migration {

    exec { 'install aws-sdk-iam into rbenv':
      path    => ['/usr/lib/rbenv/shims', '/usr/local/bin', '/usr/bin', '/bin'],
      command => 'gem install aws-sdk-iam',
      unless  => 'gem list -i aws-sdk-iam',
    }

    icinga::plugin { 'check_aws_iam_key_age':
      source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_aws_iam_key_age',
    }

    icinga::check_config { 'check_aws_iam_key_age':
      content => template('monitoring/check_aws_iam_key_age.cfg.erb'),
      require => File['/usr/lib/nagios/plugins/check_aws_iam_key_age'],
    }

    icinga::check { 'check_aws_iam_key_age':
      check_command       => 'check_aws_iam_key_age',
      use                 => 'govuk_normal_priority',
      host_name           => $::fqdn,
      check_interval      => 12h,
      service_description => "At least 1 AWS IAM Key is older then ${max_aws_iam_key_age} days and needs rotating",
      notes_url           => 'https://docs.publishing.service.gov.uk/manual/aws-iam-key-rotation.html',
      require             => Icinga::Check_config['check_aws_iam_key_age'],
    }
  }
}
