class govuk::node::s_mirrorer inherits govuk::node::s_base {
  include mirror

  class { 'akamai::event_data':
    enable  => false,
  }
}
