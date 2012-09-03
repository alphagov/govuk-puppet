class govuk_node::monitoring_server inherits govuk_node::base {
  class { 'apache2': port => '80'}
  include nagios
  include nagios::client
  include ganglia
  include graphite
}
