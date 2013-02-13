class resolvconf::reload {
  exec { '/sbin/resolvconf -u':
    refreshonly => true,
  }
}
