class govuk::node::s_datainsight inherits govuk::node::s_base {

  include nginx
  include govuk::node::s_ruby_app_server

  include rabbitmq

  include datainsight::recorders::weekly_reach
  include datainsight::recorders::todays_activity
  include datainsight::recorders::format_success
  include datainsight::recorders::insidegov
  include datainsight::recorders::everything

  class { 'govuk::apps::backdrop_read':  vhost_protected => false; }
  class { 'govuk::apps::backdrop_write': vhost_protected => false; }
  class { 'govuk::apps::backdrop_ga_collector': }

  datainsight::collector { 'ga': }
  datainsight::collector { 'insidegov': }
  datainsight::collector { 'nongovuk-reach': }

}
