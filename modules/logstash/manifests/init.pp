class logstash {
  include logstash::package
  include logstash::config
  include logstash::service
}
