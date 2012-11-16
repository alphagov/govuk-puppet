class lockrun {

  file { '/usr/local/bin/lockrun':
    source => 'puppet:///modules/lockrun/lockrun',
    mode   => '0755',
  }

}
