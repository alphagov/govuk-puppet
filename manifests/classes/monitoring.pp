class monitoring {
  include nagios::client
  include ganglia::client
  include graphite::client
  include logstash::client
  include logster
}
