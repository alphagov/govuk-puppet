# == Class: govuk_java::oracle8
#
# Installs (and removes) the oracle-java8-installer package and accepts the
# license agreement.
#
# [*ensure*]
# Whether to install the package. Default: 'present'
#
class govuk_java::oracle8 (
  $ensure = 'present'
) {

  include govuk_ppa

  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }

  package { 'oracle-java8-installer':
    ensure  => $ensure,
    require => [Exec['set-licence-selected'], Exec['set-licence-seen']],
  }

}
