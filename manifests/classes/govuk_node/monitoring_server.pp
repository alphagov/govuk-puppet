class govuk_node::monitoring_server inherits govuk_node::base {

  package { 'apache2':
    ensure => 'purged',
  }

  include nagios
  include ganglia
  include graphite

}
