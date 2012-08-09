define nagios::plugin (
  $content = undef,
  $source = undef
) {
  file { "/usr/lib/nagios/plugins/${title}":
    ensure  => 'file',
    mode    => '0755',
    content => $content,
    source  => $source,
    require => Class['nagios::client::package'],
    notify  => Class['nagios::client::service'],
  }
}
