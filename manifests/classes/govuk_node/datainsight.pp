class govuk_node::datainsight inherits govuk_node::base {

  include nginx
  include govuk_node::ruby_app_server

  include rabbitmq

  include datainsight::recorders::narrative
  # include datainsight::recorders::weekly_reach
  # include datainsight::recorders::todays_activity

  datainsight::collector { 'narrative': }
  datainsight::collector { 'ga': }
  datainsight::collector { 'nongovuk_reach': }
}
