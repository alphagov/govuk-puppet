class logstash {
  class { 'elasticsearch' : cluster => 'localhost' }
  include logstash::package
}
