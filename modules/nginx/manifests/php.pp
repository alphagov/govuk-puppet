# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class nginx::php {

  include ::php

  nginx::conf {'php':
    content => 'upstream php { server unix:/var/run/php5-fpm.sock; }',
  }

}
