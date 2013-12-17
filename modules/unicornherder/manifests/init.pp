class unicornherder {
  package { 'unicornherder':
    ensure   => '0.0.8',
    provider => 'pip',
  }
}
