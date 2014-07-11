# == Class: govuk_apt::disable_pipelining
#
# Class to explicitly disable HTTP pipelining in apt
#
# This will configure apt not to use HTTP pipelining.  This is
# to work around some HTTP proxies that fail to implement HTTP correctly.
#
# Note: apt >= 0.9.4 disables this by default (precise uses 0.8.16)
#
class govuk_apt::disable_pipelining {
  apt::conf { 'disable_http_pipelining':
    content => "Acquire::http::Pipeline-Depth 0;\n",
  }
}
