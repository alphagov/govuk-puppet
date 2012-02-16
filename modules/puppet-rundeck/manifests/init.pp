class puppetrundeck {

  package { "puppet-rundeck":
    ensure   => installed,
    provider => gem,
  }

  file { "/etc/init/puppet-rundeck.conf":
    ensure  => present,
    source  => "puppet:///modules/puppet-rundeck/puppet-rundeck",
  }

  service { "puppet-rundeck":
    ensure   => running,
    provider => upstart,
    require  => [
      Package["puppet-rundeck"],
      File["/etc/init/puppet-rundeck.conf"],
    ]
  }

}
