# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_java::openjdk7::jdk ( $ensure = present ) {

  package { 'openjdk-7-jdk':
    ensure => $ensure,
  }

}
