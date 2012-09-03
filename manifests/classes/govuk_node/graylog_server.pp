class govuk_node::graylog_server inherits govuk_node::base {
  include elasticsearch
  include nagios::client
  include nginx
  include logstash::server

  nginx::config::vhost::proxy {
    "logging.${::govuk_platform}.alphagov.co.uk":
      to      => ['localhost:9292'],
      aliases => ["graylog.${::govuk_platform}.alphagov.co.uk"],
  }
}
