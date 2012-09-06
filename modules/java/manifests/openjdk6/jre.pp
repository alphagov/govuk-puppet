class java::openjdk6::jre ( $ensure = present ) {

  package { 'openjdk-6-jre-headless':
    ensure => $ensure,
  }

}
