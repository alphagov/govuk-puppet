# This is the redirector app for redirecting Directgov and Business Link URLs
class govuk_node::redirector_server inherits govuk_node::base {
  include nginx
  include govuk::apps::redirector
}
