class fpm {
  package {
    'fpm': ensure => '0.4.10', provider => gem, require => Package['libc6-dev']; 
  }
}
