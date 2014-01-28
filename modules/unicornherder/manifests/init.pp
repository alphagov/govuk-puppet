class unicornherder (
      $version = 'present'
  ){
  package { 'unicornherder':
    ensure   => $version,
    provider => 'pip',
  }
}
