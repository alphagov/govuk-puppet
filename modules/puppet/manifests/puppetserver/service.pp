# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::puppetserver::service {
  service { 'puppetserver':
    ensure   => running,
  }

  collectd::plugin::process { 'service-puppetserver':
    regex  => '\/usr\/share\/puppetserver\/puppet-server-release\.jar',
  }
}
