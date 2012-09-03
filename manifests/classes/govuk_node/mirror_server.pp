class govuk_node::mirror_server inherits govuk_node::base {
  class { 'nginx': node_type => "mirror" }
  include mirror
}
