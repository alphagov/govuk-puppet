class python::suds {
  package { 'suds':
    ensure   => present,
    provider => 'pip';
  }
}
