# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::master::service {
  service { 'puppetmaster':
    ensure   => running,
    provider => upstart,
    restart  => '/sbin/initctl reload puppetmaster',
  }
}
