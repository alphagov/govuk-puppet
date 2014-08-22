# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define router::errorpage () {

  $app_domain = hiera('app_domain')
  $filename = "/usr/share/nginx/www/${title}.html"

  # Only triggers every 6h or if the file doesn't exist.
  exec { "update_error_page_${title}":
    command => "curl --connect-timeout 1 -sf https://static.${app_domain}/templates/${title}.html.erb -o ${filename}",
    unless  => "find ${filename} -mmin -360 -print 2>/dev/null | grep -Eqs '^${filename}$'",
    user    => 'deploy',
    group   => 'deploy',
  }

}
