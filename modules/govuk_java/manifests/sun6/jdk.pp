# = govuk_java::sun6::jdk =
#
# Installs (and removes) the sun-java6-jdk package and installs a preseed
# answer to accept the licence.
#
# [*ensure*]
#   Passed directly to the `ensure` parameter of the package resource
#   Default: present
#
class govuk_java::sun6::jdk ( $ensure = present ) {

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
