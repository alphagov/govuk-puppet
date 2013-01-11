class java::oracle7::jdk ( $ensure = present ) {

  if $ensure != absent {
    include govuk::ppa

    File['/var/local/oracle-java7-installer.preseed'] -> Package['oracle-java7-installer']
  }

  file { '/var/local/oracle-java7-installer.preseed':
    ensure => $ensure,
    source => "puppet:///modules/${module_name}/oracle-java7-installer.preseed",
  }

  package { 'oracle-java7-installer':
    ensure       => $ensure,
    responsefile => '/var/local/oracle-java7-installer.preseed',
  }

}
