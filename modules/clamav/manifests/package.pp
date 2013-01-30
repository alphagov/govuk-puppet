class clamav::package {
  package { 'clamav':
    ensure => '0.97.5',
  }
}
