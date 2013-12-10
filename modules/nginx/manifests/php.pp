class nginx::php {

  include ::php

  nginx::conf {'php':
    content => 'upstream php { server unix:/var/run/php5-fpm.sock; }',
  }

}
