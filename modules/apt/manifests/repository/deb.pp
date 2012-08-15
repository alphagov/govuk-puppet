define apt::repository::deb (
  $url,
  $dist,
  $repo = 'main'
) {

  file { "/etc/apt/sources.list.d/${title}.list":
    ensure  => present,
    content => "deb $url $dist $repo\n"
  }

}
