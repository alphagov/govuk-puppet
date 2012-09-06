class java::openjdk6::jdk ( $ensure = present ) {

  package { 'openjdk-6-jdk':
    ensure => $ensure,
  }

}
