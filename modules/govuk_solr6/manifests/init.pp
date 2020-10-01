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
    config { 'solr.init':
      init_file => 'puppet:///modules/govuk_solr6/solr.init.sh',
    }

    configset { 'ckan28':
      schema_xml => 'puppet:///modules/govuk_solr6/ckan28.schema.xml',
    }

    service { 'solr':
      ensure    => running,
      enable    => true,
      subscribe => Package['solr'],
    }

    core { 'example_core_ckan28':
      configset => 'ckan28',
    }
  }
}
