# == Class: govuk::node::s_performance_frontend
#
# Class to define machines that run the Performance Platform frontend.
#
class govuk::node::s_performance_frontend inherits govuk::node::s_base {
  include nginx
  include nodejs

  include govuk::apps::performanceplatform_big_screen_view
  include govuk::apps::performanceplatform_notifier
  include govuk::apps::screenshot_as_a_service
  include govuk::apps::spotlight
}
