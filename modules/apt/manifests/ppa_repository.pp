define apt::ppa_repository($publisher, $repo, $ensure='present') {
  exec { "apt-update-ppa-${name}":
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }

  case $ensure {
    'present': {
      exec { "add_repo_$name":
        command => "/usr/bin/add-apt-repository ppa:$publisher/$repo",
        creates => "/etc/apt/sources.list.d/${publisher}-${repo}-${::lsbdistcodename}.list",
        require => Package['python-software-properties'],
        notify  => Exec["apt-update-ppa-${name}"],
      }
    }
    default: {
      # do something here...
    }
  }
}
