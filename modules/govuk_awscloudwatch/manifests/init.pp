# == Class: govuk_awscloudwatch
#
# Installs the Apt repo for the AWS Cloudwatch package, and installs the AWS Cloudwatch from the Apt repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname of the Apt mirror containing the awscloudwatch repo
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of the Apt mirror containing the awscloudwatch repo
#
class govuk_awscloudwatch (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
  $log_files,
  $aws_region,
)
{
  apt::source { 'awscloudwatch':
    ensure       => present,
    location     => "http://${apt_mirror_hostname}/awscloudwatch",
    release      => 'stable',
    repos        => 'main',
    architecture => $::architecture,
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'amazon-cloudwatch-agent':
    ensure  => present,
    require => Apt::Source['awscloudwatch'],
  }

  file { 'amazon-cloudwatch-config':
    ensure => present,
    path => '/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml',
    content => template('govuk_awscloudwatch/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
