class resolvconf {
  anchor { 'resolvconf::begin': }

  class { 'resolvconf::package':
    notify  => Class['resolvconf::config'],
    require => Anchor['resolvconf::begin'],
  }

  class { 'resolvconf::config':
    notify  => Class['resolvconf::reload'],
  }

  class { 'resolvconf::reload':
    notify  => Anchor['resolvconf::end'],
  }

  anchor { 'resolvconf::end': }
}
