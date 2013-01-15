################################################################################
# Definition: wget::authfetch
#
# This class will download files from the internet.  You may define a web proxy
# using $http_proxy if necessary. Username must be provided. And the user's
# password must be stored in the password variable within the .wgetrc file.
#
################################################################################
define wget::authfetch($source, $destination, $user, $password='', $timeout='0') {
  if $::http_proxy {
    $environment = [ "HTTP_PROXY=${::http_proxy}", "http_proxy=${::http_proxy}", "WGETRC=/tmp/wgetrc-${name}" ]
  }
  else {
    $environment = [ "WGETRC=/tmp/wgetrc-${name}" ]
  }
  file { "/tmp/wgetrc-${name}":
    owner   => root,
    mode    => '0600',
    content => "password=${password}",
  } ->
  exec { "wget-auth-${name}":
    command     => "/usr/bin/wget --user=${user} --output-document=${destination} ${source}",
    timeout     => $timeout,
    unless      => "/usr/bin/test -s ${destination}",
    environment => $environment,
  }
}
