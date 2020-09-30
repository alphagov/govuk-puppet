# == Class: govuk_solr6::config
#
# Configures solr according to data.gov.uk needs.
#
define govuk_solr6::config (
  $init_file = 'puppet:///modules/govuk_solr6/solr.init.sh',
) {
  file {'/etc/init.d/solr.init.sh':
    ensure => file,
    mode   => '0755',
    source => $init_file,
  }
}
