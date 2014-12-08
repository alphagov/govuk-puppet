# = govuk_java::openjdk6::jdk =
#
# Installs (and removes) the openjdk-6-jdk package
#
# [*ensure*]
#   Passed directly to the `ensure` parameter of the package resource
#   Default: present
#
class govuk_java::openjdk6::jdk ( $ensure = present ) {

  package { 'openjdk-6-jdk':
    ensure => $ensure,
  }

}
