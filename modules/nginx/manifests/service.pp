# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class nginx::service {

  service { 'nginx':
    ensure    => running,
    start     => '/etc/init.d/nginx start || { killall nginx; /etc/init.d/nginx start;}',
    hasstatus => true,
    restart   => '/etc/init.d/nginx configtest && /etc/init.d/nginx reload',
  }

}
