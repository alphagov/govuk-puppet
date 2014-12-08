# = govuk_java::openjdk6::jre =
#
# Installs (and removes) the openjdk-6-jre package
#
# [*ensure*]
#   Passed directly to the `ensure` parameter of the package resource
#   Default: present
#
class govuk_java::openjdk6::jre ( $ensure = present ) {

  package { 'openjdk-6-jre-headless':
    ensure => $ensure,
  }

}
