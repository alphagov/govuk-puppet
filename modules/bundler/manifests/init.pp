class bundler {

  package { 'bundler':
    ensure   => '1.1.4',
    provider => 'system_gem',
  }

}
