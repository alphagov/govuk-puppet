# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_java::openjdk6::jdk ( $ensure = present ) {

  package { 'openjdk-6-jdk':
    ensure => $ensure,
  }

}
