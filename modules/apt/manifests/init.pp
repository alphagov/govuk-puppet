class apt {
  $root = '/etc/apt'
  $provider = '/usr/bin/apt-get'

  Exec["apt_update"] -> Package <| |>

  define key($ensure, $apt_key_url = "http://www.example.com/apt/keys") {
    case $ensure {
      "present": {
        exec { "apt-key present $name":
          command => "/usr/bin/wget -q $apt_key_url/$name -O -|/usr/bin/apt-key add -",
          unless => "/usr/bin/apt-key list|/bin/grep -c $name",
          before => Exec["apt_update"]
        }
      }
      "absent": {
        exec { "apt-key absent $name":
          command => "/usr/bin/apt-key del $name",
          onlyif => "/usr/bin/apt-key list|/bin/grep -c $name",
        }
      }
      default: {
        fail "Invalid 'ensure' value '$ensure' for apt::key"
      }
    }
  }

  file { "sources.list":
    name => "${root}/sources.list",
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
  }

  file { "sources.list.d":
    name => "${root}/sources.list.d",
    ensure => directory,
    owner => root,
    group => root,
  }

  exec { "apt_update":
    command => "${provider} update",
  }

  package { "python-software-properties":
    ensure => installed,
  }

  define ppa_repository($publisher, $repo, $ensure="present") {

    exec { "apt-update-ppa-${name}":
      command     => "/usr/bin/apt-get update",
      refreshonly => true,
    }

    case $ensure {
      "present": {
        exec { "add_repo_$name":
          command => "/usr/bin/add-apt-repository ppa:$publisher/$repo",
          creates => "/etc/apt/sources.list.d/$publisher-$repo-$::lsbdistcodename.list",
          require => [Package["python-software-properties"]],
          notify  => Exec["apt-update-ppa-${name}"],
        }
      }
      "absent": {
        # do something here...
      }
    }
  }

  define deb_repository($url, $repo, $ensure="present", $dist="${::lsbdistcodename}", $key_url=false, $key_name=false) {
    exec { "apt-update-repo-$name":
      command => "/usr/bin/apt-get update",
      refreshonly => true
    }

    if $key_name {
      apt::key { $key_name:
        apt_key_url => $key_url,
        ensure => present
      }
    }

    case $ensure {
      "present": {
        exec { "add_repo_$name":
          command => "/bin/echo 'deb $url $dist $repo' >> /etc/apt/sources.list",
          unless  => "/bin/grep -Fxqe 'deb $url $dist $repo' /etc/apt/sources.list",
          require => [Package["python-software-properties"]],
          notify  => Exec["apt-update-repo-$name"],
        }
      }
      "absent": {
        # do something here...
      }
    }
  }

  define deb_key($keyserver = "keyserver.ubuntu.com") {
    exec { "apt-update-key-$name":
      command => "/usr/bin/apt-get update",
      refreshonly => true
    }
    exec { "add_key_$name":
      command => "/usr/bin/apt-key adv --keyserver $keyserver --recv $name",
      unless  => "apt-key list | grep -Fqe '${name}'",
      notify  => Exec["apt-update-key-$name"],
    }
  }
}
