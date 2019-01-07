# == Class: govuk_aws_xray_daemon
#
# Installs the Apt repo for the AWS X-Ray daemon, and installs the AWS X-Ray daemon from the Apt repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname of the Apt mirror containing the aws-xray-daemon repo
#
# [*aws_access_key_id*]
#   The AWS access key for the IAM user that has permissions to assume the X-Ray daemon traces role
#
# [*aws_secret_access_key*]
#   The AWS secret access key for the IAM user that has permissions to assume the X-Ray daemon traces role
#
# [*aws_xray_daemon_traces_role_arn*]
#   The ARN of the role to be assumed by the AWS X-Ray daemon
#
class govuk_aws_xray_daemon (
  $apt_mirror_hostname = undef,
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $aws_xray_daemon_traces_role_arn = undef,
)
{
  apt::source { 'aws-xray-daemon':
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/aws-xray-daemon",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  user { 'xray':
    ensure     => present,
    name       => 'xray',
    home       => '/home/xray',
    managehome => true,
    shell      => '/bin/false',
    system     => true,
  }

  file { '/home/xray':
    ensure  => directory,
    owner   => 'xray',
    group   => 'xray',
    mode    => '0750',
    require => User['xray'],
  }

  file { '/home/xray/.aws':
    ensure => directory,
    owner  => 'xray',
    group  => 'xray',
    mode   => '0700',
  }

  file { '/home/xray/.aws/credentials':
    ensure  => present,
    owner   => 'xray',
    group   => 'xray',
    mode    => '0600',
    content => template('govuk_aws_xray_daemon/credentials.erb'),
    notify  => Service['govuk-aws-xray-daemon'],
  }

  package { 'xray':
    ensure  => latest,
    require => Apt::Source['aws-xray-daemon'],
  }

  file { '/etc/amazon/xray/cfg.yaml':
    ensure  => present,
    owner   => 'xray',
    group   => 'xray',
    mode    => '0644',
    content => template('govuk_aws_xray_daemon/etc/amazon/xray/cfg.yaml.erb'),
    require => Package['xray'],
    notify  => Service['govuk-aws-xray-daemon'],
  }

  @logrotate::conf { 'govuk-aws-xray-daemon':
    ensure  => present,
    matches => '/var/log/xray/xray.log',
    maxsize => '100M',
  }

  service { 'govuk-aws-xray-daemon':
    ensure => running,
    name   => 'xray',
  }
}
