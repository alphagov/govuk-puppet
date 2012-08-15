define apt::repository(
  $type = 'deb',
  $key = undef,

  # deb type options
  $url = undef,

  # ppa type options,
  $owner = undef,

  # common options
  $repo = 'main',
  $dist = 'NOTSET'
) {

  if !($type in ['deb', 'ppa']) {
    fail 'Unknown $type for apt::repository. Should be one of "apt", "ppa".'
  }

  if $key != undef {
    apt::key { $key: }

    if $type == 'deb' {
      Apt::Key[$key] -> Apt::Repository::Deb[$title]
    } else {
      Apt::Key[$key] -> Apt::Repository::Ppa[$title]
    }
  }

  if $dist == 'NOTSET' {
    if $::lsbdistcodename != '' {
      $dist_real = $::lsbdistcodename
    } else {
      $dist_real = 'lucid'
    }
  } else {
    $dist_real = $dist
  }

  if $type == 'deb' {
    apt::repository::deb { $title:
      url     => $url,
      repo    => $repo,
      dist    => $dist_real,
      require => Class['apt'],
      notify  => Class['apt::update'],
    }
  } else {
    apt::repository::ppa { $title:
      owner   => $owner,
      repo    => $repo,
      dist    => $dist_real,
      require => Class['apt'],
      notify  => Class['apt::update'],
    }
  }

}
