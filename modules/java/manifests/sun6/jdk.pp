class java::sun6::jdk ( $ensure = present ) {

  if $ensure != absent {
    include govuk::ppa

    File['/var/local/sun6_jre.preseed'] -> Package['sun-java6-jdk']
  }

  file { '/var/local/sun6_jdk.preseed':
    ensure => $ensure,
    source => "puppet:///modules/${module_name}/sun6_jdk.preseed",
  }

  package { 'sun-java6-jdk':
    ensure       => $ensure,
    responsefile => '/var/local/sun6_jdk.preseed',
  }

}
