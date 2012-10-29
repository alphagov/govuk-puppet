class hosts::skyscape::dead_hosts ($platform = $::govuk_platform) {
  host { 'calendars.cluster.router.production': ensure => absent, ip => '10.2.1.1'}
  host { 'calendars.router.production'        : ensure => absent, ip => '10.2.1.1'}
  host { "router-mongo-1.router.${platform}"  : ensure => absent, ip => '10.1.0.5' }
  host { "router-mongo-2.router.${platform}"  : ensure => absent, ip => '10.1.0.6' }
  host { "router-mongo-3.router.${platform}"  : ensure => absent, ip => '10.1.0.7' } 
}
