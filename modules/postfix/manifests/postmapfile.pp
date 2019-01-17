# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define postfix::postmapfile(
  $content,
) {
  $filename = "/etc/postfix/${title}"

  Package['postfix']
  -> file { $filename:
    ensure  => present,
    mode    => '0644',
    content => $content,
  }
  ~> exec { "postmap_${title}":
    command     => "/usr/sbin/postmap ${filename}",
    refreshonly => true,
  }
}

