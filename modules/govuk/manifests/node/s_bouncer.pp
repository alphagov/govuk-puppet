# == Class: govuk::node::s_bouncer
#
# Sets up a machine to run the bouncer app and redirect old domains
# to GOV.UK.
#
class govuk::node::s_bouncer inherits govuk::node::s_base {

  include govuk_bouncer::gor
  include govuk::node::s_app_server
  include nginx
}
