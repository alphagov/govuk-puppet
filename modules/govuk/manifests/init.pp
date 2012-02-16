class govuk::testing_tools {
  package { 'libqt4-dev':
    ensure => installed,
    require => Exec["add_repo_kubuntu-backports"],
  }
  package { 'xvfb':
    ensure => installed;
  }
  file { "/etc/init/xvfb.conf":
    ensure  => present,
    source  => "puppet:///modules/govuk/xvfb.conf",
  }

  service { "xvfb":
    ensure   => running,
    provider => upstart,
    require  => [
      Package["xvfb"],
      File["/etc/init/xvfb.conf"],
    ]
  }

  apt::ppa_repository { "kubuntu-backports":
    publisher => "kubuntu-ppa",
    repo      => "backports",
  }

}

class govuk::signing_key {
  include apt
  apt::key { "gds.asc":
    ensure      => present,
    apt_key_url => "https://github.com/downloads/alphagov/packages",
  }
}

class govuk::repository {
  include apt
  include govuk::signing_key

  apt::deb_repository { "gds":
    url     => "http://gds-packages.s3-website-us-east-1.amazonaws.com",
    dist    => "current",
    repo    => "main",
    require => Class["govuk::signing_key"],
  }
}
