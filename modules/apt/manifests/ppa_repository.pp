define apt::ppa_repository($publisher, $repo, $ensure='present') {
  case $ensure {
    'present': {
      exec { "add_repo_$name":
        command => "/usr/bin/add-apt-repository ppa:$publisher/$repo && /usr/bin/apt-get update",
        creates => "/etc/apt/sources.list.d/${publisher}-${repo}-${::lsbdistcodename}.list",
        require => Package['python-software-properties']
      }
    }
    'absent': {
      file { "/etc/apt/sources.list.d/${publisher}-${repo}-${::lsbdistcodename}.list":
        ensure => absent,
      }
      exec { "remove_repo_$name":
        command => '/usr/bin/apt-get update',
        require => File["/etc/apt/sources.list.d/${publisher}-${repo}-${::lsbdistcodename}.list"],
      }
    }
    default: {
      # do something here...
    }
  }
}
