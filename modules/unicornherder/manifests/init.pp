class unicornherder {
  package { 'unicornherder':
    ensure   => '0.0.3',
    provider => 'pip',
  }
}
