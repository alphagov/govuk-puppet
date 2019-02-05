# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class nginx::restart {

  exec { '/etc/init.d/nginx configtest && (/etc/init.d/nginx restart || { nginx -s quit; /etc/init.d/nginx start;})':
    refreshonly => true,
  }

}
