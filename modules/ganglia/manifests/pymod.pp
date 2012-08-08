define ganglia::pymod (
  $content = undef,
  $source = undef
) {
  file { "/usr/lib/ganglia/python_modules/${title}.py":
    ensure  => 'file',
    mode    => '0755',
    content => $content,
    source  => $source,
    require => Class['ganglia::client::package'],
    notify  => Class['ganglia::client::service'],
  }
}
