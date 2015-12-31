# == Class: govuk::node::s_performance_frontend
#
# Class to define machines that run the Performance Platform frontend.
#
class govuk::node::s_performance_frontend inherits govuk::node::s_base {
  include nginx
  include nodejs
}
