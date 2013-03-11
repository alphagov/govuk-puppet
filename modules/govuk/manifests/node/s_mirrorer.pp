class govuk::node::s_mirrorer inherits govuk::node::s_base {
  $enable_akamai_event_data_logging = str2bool(extlookup('enable_akamai_event_data_logging', "no"))

  include mirror

  if $enable_akamai_event_data_logging {
    notice("Oops this is not what I EXPECT")
    include akamai::event_data
  }
}
