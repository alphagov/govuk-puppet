# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define router::errorpage () {
  $app_domain = hiera('app_domain_internal')

  # Only triggers every 6h or if the file doesn't exist.
  $filename = "/usr/share/nginx/www/${title}.html"

  $static_url = "https://static.${app_domain}/templates/${title}.html.erb"

# We're dealing with a chicken and egg problem when building gov.uk here, static is not up before router, and router needs static for its error pages templates
# To solve this we want router to try to get the templates from static
# If that fails : keep the templates it has
# If that fails and it has no templates: we generate basic tamplates for it.
  $cmd = "curl --connect-timeout 1 -sf ${static_url} -o ${filename} || if [ ! -f ${filename} ]; then echo '<!DOCTYPE html><html><b>${title}</b></html>' > ${filename}; fi"

  exec { "update_error_page_${title}":
    command => $cmd,
    unless  => "find ${filename} -mmin -360 -print 2>/dev/null | grep -Eqs '^${filename}$'",
    user    => 'deploy',
    group   => 'deploy',
    require => Class['curl'],
  }

}
