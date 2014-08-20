# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps::base {

  file { '/etc/licensing':
    ensure => directory,
    mode   => '0755',
    owner  => 'deploy',
    group  => 'deploy',
  }
}
