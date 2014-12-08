# = govuk_java::openjdk7::jre =
#
# Installs (and removes) the openjdk-7-jre package
#
# [*ensure*]
#   Passed directly to the `ensure` parameter of the package resource
#   Default: present
#
class govuk_java::openjdk7::jre ( $ensure = present ) {

  package { 'openjdk-7-jre-headless':
    ensure => $ensure,
  }

}
