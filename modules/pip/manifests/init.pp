class pip {
  package { 'python-pip':
    ensure  => '1.1',
    require => [Package['python'], Package['python-setuptools']];
  }
}
