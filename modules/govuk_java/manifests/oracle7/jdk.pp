# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_java::oracle7::jdk ( $ensure = present ) {

  if $ensure != absent {
    include govuk::ppa

    File['/var/cache/oracle-jdk7-installer'] -> Exec['download-oracle-java7'] ->
      File['/var/local/oracle-java7-installer.preseed'] -> Package['oracle-java7-installer']

    file { '/var/cache/oracle-jdk7-installer':
      ensure => directory,
    }

    exec { 'download-oracle-java7':
      command => '/usr/bin/curl -o jdk-7u9-linux-x64.tar.gz https://gds-public-readable-tarballs.s3.amazonaws.com/jdk-7u9-linux-x64.tar.gz',
      cwd     => '/var/cache/oracle-jdk7-installer',
      require => Package['curl'],
      timeout => 3600,
      unless  => '/usr/bin/test "`shasum -a 256 jdk-7u9-linux-x64.tar.gz`" = "1b39fe2a3a45b29ce89e10e59be9fbb671fb86c13402e29593ed83e0b419c8d7  jdk-7u9-linux-x64.tar.gz"',
    }
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
