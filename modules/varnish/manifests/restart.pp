# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class varnish::restart {

  exec { '/etc/init.d/varnish restart':
    refreshonly => true,
  }

}
