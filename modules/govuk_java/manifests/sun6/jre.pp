# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_java::sun6::jre ( $ensure = present ) {

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
