# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define postfix::postmapfile() {
  $filename = "/etc/postfix/${title}"

  file { $filename:
    ensure  => present,
    mode    => '0644',
    content => template("postfix/etc/postfix/${title}.erb"),
  }
  ~> exec { "postmap_${title}":
    command     => "/usr/sbin/postmap ${filename}",
    refreshonly => true,
    require     => Package['postfix'],
  }
}

