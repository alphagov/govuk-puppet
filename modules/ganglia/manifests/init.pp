class ganglia {

  anchor { 'ganglia::begin':
    notify => Class['ganglia::service'];
  }

  class { 'ganglia::package':
    require => Anchor['ganglia::begin'],
    notify  => Class['ganglia::service'];
  }

  class { 'ganglia::config':
    require   => Class['ganglia::package'],
    notify    => Class['ganglia::service'];
  }

  class { 'ganglia::firewall':
    require => Class['ganglia::config'],
  }

  class { 'ganglia::service':
    notify => Anchor['ganglia::end'],
  }

  anchor { 'ganglia::end':
    require => Class['ganglia::firewall'],
  }

}
