class govuk::node::s_datainsight inherits govuk::node::s_base {

  include nginx
  include govuk::node::s_ruby_app_server

  include rabbitmq

  include datainsight::recorders::weekly_reach
  include datainsight::recorders::todays_activity
  include datainsight::recorders::format_success
  include datainsight::recorders::insidegov
  include datainsight::recorders::everything

  if str2bool(extlookup('govuk_enable_backdrop', 'no')) {
    include performance_platform::backdrop
  }

  datainsight::collector { 'ga': }
  datainsight::collector { 'insidegov': }
  datainsight::collector { 'nongovuk-reach': }
}
