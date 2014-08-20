# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class nginx::service {

  service { 'nginx':
    ensure    => running,
    hasstatus => true,
    restart   => '/etc/init.d/nginx reload',
  }

}
