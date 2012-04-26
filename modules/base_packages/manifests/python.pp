class base_packages::python {
  package {
    [
      'python',
      'python-dev',
      'python-setuptools',
      'python-pip',
    ]:
    ensure => installed
  }
}
