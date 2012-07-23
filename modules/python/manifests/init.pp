class python {
  package { ['python', 'python-dev', 'python-setuptools']:
    ensure => installed
  }
}
