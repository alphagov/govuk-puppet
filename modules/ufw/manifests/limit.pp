define ufw::limit($proto='tcp') {
  exec { "ufw limit $name/$proto":
    unless  => "ufw status | grep -E \"^$name/$proto +LIMIT +Anywhere\"",
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }
}
