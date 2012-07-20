class pip {
  include python
  package { 'python-pip':
    ensure => '1.1',
    require => Package['python-setuptools'];
  }
}
