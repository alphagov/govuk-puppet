class unicornherder {
  package { 'unicornherder':
    ensure   => '0.0.1',
    provider => 'pip',
  }
}
