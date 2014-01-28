class unicornherder (
      $version = '0.0.4'
  ){
  package { 'unicornherder':
    ensure   => $version,
    provider => 'pip',
  }
}
