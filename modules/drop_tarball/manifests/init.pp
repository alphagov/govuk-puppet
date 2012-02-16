# $location: top level directory for expanded package
# $url:      URL to tarball

define drop_tarball($url, $location, $user="root", $timeout=1200) {
  include apt
  include base_packages

  package { 'pax': }

  if (($url =~ /\.tar.gz$/) or ($url =~ /\.tgz$/)) {
    $pax_opts = "-rz"
  } elsif (($url =~ /\.tar.bz2$/) or ($url =~ /\.tbz$/)) {
    $pax_opts = "-rj"
  }

  $re_opts = "-s '#^[^/]*#${location}.tmp#'"

  exec { "drop_tarball $name":
    command => "/usr/bin/curl -sL $url | /usr/bin/pax $pax_opts $re_opts && \
                /bin/mv $location.tmp $location && \
                chown -R $user:$user $location",
    creates => "$location",
    unless  => "/usr/bin/test -s $location",
    timeout => $timeout,
    require => [Package["pax"], Package["curl"]],
  }
}
