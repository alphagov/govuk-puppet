class logstash {
  class { 'elasticsearch' : cluster => 'localhost' }
  include logstash::package
  include logstash::config
  include logstash::service
}
