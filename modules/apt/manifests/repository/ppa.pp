define apt::repository::ppa (
  $owner,
  $dist,
  $repo = 'main'
) {

  $sources_list_file = "/etc/apt/sources.list.d/${owner}-${repo}-${dist}.list"

  exec { "/usr/bin/add-apt-repository ppa:${owner}/${repo}":
    creates => $sources_list_file,
    before  => File[$sources_list_file],
  }

  # explicitly declare file resource due to recursive management of the
  # /etc/apt/sources.list.d directory
  file { $sources_list_file:
    ensure => present,
  }

}
