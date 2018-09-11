# == Class: govuk_aws_xray_daemon
#
# Installs the Apt repo for the AWS X-Ray daemon, and installs the AWS X-Ray daemon from the Apt repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   The hostname of the Apt mirror containing the aws-xray-daemon repo
#
class govuk_aws_xray_daemon (
  $apt_mirror_hostname,
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
    ensure => present,
    name   => 'xray',
    shell  => '/bin/false',
    system => true,
  }

  package { 'xray':
    ensure  => latest,
    require => Apt::Source['aws-xray-daemon'],
  }
}
