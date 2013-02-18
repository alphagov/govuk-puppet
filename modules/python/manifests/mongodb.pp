class python::mongodb {
  package { 'pymongo':
    ensure   => present,
    provider => 'pip';
  }
}
