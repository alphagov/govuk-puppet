class unicornherder {
  package { 'unicornherder':
    ensure   => '0.0.4',
    provider => 'pip',
  }
}
