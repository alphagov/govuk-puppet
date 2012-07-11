class logstash::client {
  include logstash::client::package
  include logstash::client::config
  include logstash::client::service
}
