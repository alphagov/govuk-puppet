# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class postfix::service {
  service { 'postfix':
    ensure  => running,
    require => Class['postfix::package']
  }
}
