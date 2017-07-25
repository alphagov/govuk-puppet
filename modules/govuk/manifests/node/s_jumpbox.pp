# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_jumpbox inherits govuk::node::s_base {

  if $::aws_migration {
    file { '/usr/local/bin/ssh-proxy':
      ensure => 'present',
      mode   => '0775',
      source => 'puppet:///modules/govuk/node/s_jumpbox/ssh-proxy',
    }
  }

}
