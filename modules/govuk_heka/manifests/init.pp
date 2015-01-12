# == Class: govuk_heka
#
# Base classes for all Heka nodes.
#
class govuk_heka {
  include govuk_heka::global
  include govuk_heka::repo

  include heka
  include heka::plugin::dashboard
  include heka::plugin::tcp_output
}
