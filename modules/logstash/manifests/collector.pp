define logstash::collector (
  $content = undef,
  $source = undef
) {

  file { "/etc/logstash/logstash-client/${title}.conf":
    ensure  => 'file',
    content => $content,
    source  => $source,
    require => Class['logstash::client::config'],
    notify  => Class['logstash::client::service'],
  }
}
