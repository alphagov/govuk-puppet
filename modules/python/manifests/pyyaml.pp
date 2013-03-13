class python::pyyaml {
  package { 'pyyaml':
    ensure   => present,
    provider => 'pip',
  }
}
