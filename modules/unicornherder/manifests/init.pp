class unicornherder {
  package { 'unicornherder':
    ensure   => '0.0.2',
    provider => 'pip',
  }
}
