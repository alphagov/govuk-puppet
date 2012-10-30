class java::sun6::jre ( $ensure = present ) {

  if $ensure != absent {
    include govuk::ppa

    File['/var/local/sun6_jre.preseed'] -> Package['sun-java6-jre']
  }

  file { '/var/local/sun6_jre.preseed':
    ensure => $ensure,
    source => "puppet:///modules/${module_name}/sun6_jre.preseed",
  }

  package { 'sun-java6-jre':
    ensure       => $ensure,
    responsefile => '/var/local/sun6_jre.preseed',
  }

}
