class logstash::client {
  include logstash::package
  include logstash::client::config
  include logstash::client::service
}
