# = govuk_java::openjdk8::jdk =
#
# Installs (and removes) the openjdk-8-jdk package
#
# [*ensure*]
#   Passed directly to the `ensure` parameter of the package resource
#   Default: present
#
class govuk_java::openjdk8::jdk ( $ensure = present ) {

  package { 'openjdk-8-jdk':
    ensure => $ensure,
  }

}
