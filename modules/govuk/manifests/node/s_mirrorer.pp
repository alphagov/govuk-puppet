class govuk::node::s_mirrorer inherits govuk::node::s_base {
  $enable_akamai_event_data_logging = str2bool(extlookup('enable_akamai_event_data_logging', "no"))

  include mirror

  class { 'akamai::event_data':
    enable  => $enable_akamai_event_data_logging,
  }
}
