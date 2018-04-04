# = govuk_java::openjdk8::jre =
#
# Installs (and removes) the openjdk-8-jre package
#
# [*ensure*]
#   Passed directly to the `ensure` parameter of the package resource
#   Default: present
#
class govuk_java::openjdk8::jre ( $ensure = present ) {

  package { 'openjdk-8-jre-headless':
    ensure => $ensure,
  }

}
