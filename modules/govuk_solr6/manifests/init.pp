# == Class: govuk_solr6
#
# Installs solr 6.x using custom deb package, enables and starts
# service.
#
# === Parameters:
#
# [*present*]
#   Whether package should _actually_ be present.
#
class govuk_solr6 (
  $present = true,
) {
  $package_ensure = $present ? {
    false => absent,
    true  => present,
  }

  include govuk_solr6::repo

  package { 'solr':
    ensure => $package_ensure,
  }

  if $present {
    service { 'solr':
      ensure => running,
      enable => true,
    }

    Package['solr'] ~> Service['solr']
  }
}
