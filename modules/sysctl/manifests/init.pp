# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class sysctl {
  file { '/etc/sysctl.d/10-disable-timestamps.conf':
    source => 'puppet:///modules/sysctl/10-disable-timestamps.conf',
    owner  => root,
    group  => root,
  }
}
