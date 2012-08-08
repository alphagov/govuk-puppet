define ganglia::pyconf (
  $content = undef,
  $source = undef
) {
  file { "/etc/ganglia/conf.d/${title}.pyconf":
    ensure  => 'file',
    content => $content,
    source  => $source,
    require => Class['ganglia::client::package'],
    notify  => Class['ganglia::client::service'],
  }
}
