# == Class: govuk_java::oracle
#
# Installs (and removes) the oracle-java8-installer package and accepts the
# license agreement.
#
class govuk_java::oracle (
  $version,
) {

  include govuk_ppa

  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }

  package { "oracle-java${version}-installer":
    ensure  => present,
    require => [Exec['set-licence-selected'], Exec['set-licence-seen']],
  }

}
