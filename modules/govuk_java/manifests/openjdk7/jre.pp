# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_java::openjdk7::jre ( $ensure = present ) {

  package { 'openjdk-7-jre-headless':
    ensure => $ensure,
  }

}
