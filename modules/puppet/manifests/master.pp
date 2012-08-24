class puppet::master($unicorn_port='9090') {
  include puppet::repository
  include nginx
  include unicornherder

  anchor {'puppet::master::begin':
    notify => Class['puppet::master::service'],
  }
  class{'puppet::master::package':
    require => [
        Class['unicornherder'],
        Anchor['puppet::master::begin']
    ],
  }
  class{'puppet::master::config':
    unicorn_port => $unicorn_port,
    require      => Class['puppet::master::package'],
    notify       => Class['puppet::master::service'],
  }
  class{'puppet::master::service':
    notify  => Anchor['puppet::master::end'],
  }
  anchor {'puppet::master::end': }
}
