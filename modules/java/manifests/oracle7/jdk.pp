class java::oracle7::jdk ( $ensure = present ) {

  if $ensure != absent {
    include govuk::ppa
  }

  package { 'oracle-java7-installer':
    ensure => $ensure,
  }

}
