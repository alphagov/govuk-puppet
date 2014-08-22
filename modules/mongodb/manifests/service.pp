# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::service {

  service { 'mongodb':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
  }

}
