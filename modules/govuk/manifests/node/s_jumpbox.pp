# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_jumpbox inherits govuk::node::s_base {

  include govuk_awscloudwatch

  file { '/usr/local/bin/ssh-proxy':
    ensure => 'present',
    mode   => '0775',
    source => 'puppet:///modules/govuk/node/s_jumpbox/ssh-proxy',
  }

  file { 'amazon-cloudwatch-agent.json':
    ensure => 'present',
    path   =>  '/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json',
    mode   => '0644',
    source => 'puppet:///modules/govuk/node/s_jumpbox/amazon-cloudwatch-agent.json',
  }

  service { 'amazon-cloudwatch-agent':
    ensure    => 'running',
    subscribe => File['amazon-cloudwatch-agent.json'],
  }
}
