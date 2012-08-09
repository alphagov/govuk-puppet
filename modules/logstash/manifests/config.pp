class logstash::config {

  file { '/etc/logstash/grok-patterns/' :
    source  => 'puppet:///modules/logstash/etc/logstash/grok-patterns/',
    recurse => true,
  }

}
