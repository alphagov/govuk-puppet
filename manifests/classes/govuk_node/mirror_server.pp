class govuk_node::mirror_server inherits govuk_node::base {
  class { 'nginx': node_type => "mirror" }
  nginx::config::vhost::mirror { 'www.gov.uk':}
  include mirror
}
