#######latest#########################################################################
# Definition: wget::fetch
#
# This class will download files from the internet.  You may define a web proxy
# using $http_proxy if necessary.
#
################################################################################
define wget::fetch($source, $destination, $timeout='0') {

  # using "unless" with /usr/bin/test instead of "creates" to re-attempt download
  # on empty files.
  # wget creates an empty file withhen a download fails, and then it wouldn't try
  # again to download then file
  if $::http_proxy {
    $environment = [ "HTTP_PROXY=$::http_proxy", "http_proxy=$::http_proxy" ]
  }
  else {
    $environment = []
  }
  exec { "wget-$name":
    command     => "/usr/bin/wget --output-document=$destination $source",
    timeout     => $timeout,
    unless      => "/usr/bin/test -s $destination",
    environment => $environment,
  }
}
