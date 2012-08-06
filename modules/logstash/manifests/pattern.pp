define logstash::pattern (
  $content = undef,
  $source = undef
) {

  file { "/etc/logstash/grok-patterns/${title}":
    ensure  => 'file',
    content => $content,
    source  => $source,
    require => Class['logstash::client::config'],
    notify  => Class['logstash::client::service'],
  }
}
