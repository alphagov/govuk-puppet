class java::oracle7::jdk ( $ensure = present ) {

  if $ensure != absent {
    include java::oracle7::repository

    Class['java::oracle7::repository'] -> Package['oracle-java7-installer']
  }

  package { 'oracle-java7-installer':
    ensure => $ensure,
  }

}
