# = govuk_java::openjdk7::jdk =
#
# Installs (and removes) the openjdk-7-jdk package
#
# [*ensure*]
#   Passed directly to the `ensure` parameter of the package resource
#   Default: present
#
class govuk_java::openjdk7::jdk ( $ensure = present ) {

  package { 'openjdk-7-jdk':
    ensure => $ensure,
  }

}
