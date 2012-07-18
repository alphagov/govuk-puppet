define apt::deb_repository($url, $repo, $ensure='present', $dist=$::lsbdistcodename, $key_url=false, $key_name=false) {
  exec { "apt-update-repo-$name":
    command     => '/usr/bin/apt-get update',
    refreshonly => true
  }

  if $key_name {
    apt::key { $key_name:
      ensure      => present,
      apt_key_url => $key_url,
    }
  }

  case $ensure {
    'present': {
      # TODO: much simpler to manage as a file resource in /etc/apt/sources.list.d/ instead of munging
      # the sources.list file
      exec { "add_repo_$name":
        command => "/bin/echo 'deb $url $dist $repo' >> /etc/apt/sources.list",
        unless  => "/bin/grep -Fxqe 'deb $url $dist $repo' /etc/apt/sources.list",
        require => Package['python-software-properties'],
        notify  => Exec["apt-update-repo-$name"],
      }
    }
    default: {
      # do something here...
    }
  }
}

