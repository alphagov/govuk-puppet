# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define router::errorpage () {

  if $::aws_migration {
    $app_domain = hiera('app_domain_internal')
  } else {
    $app_domain = hiera('app_domain')
  }

  # Only triggers every 6h or if the file doesn't exist.
  $filename = "/usr/share/nginx/www/${title}.html"

  if $::aws_migration {
    $s3_artefact_bucket = "govuk-${::aws_environment}-artefact"
    $s3_url = "s3://${s3_artefact_bucket}/templates/${title}.html.erb"
    $cmd = "aws --region eu-west-1 s3 cp ${s3_url} ${filename}"

  } else {
    $static_url = "https://static.${app_domain}/templates/${title}.html.erb"
    $cmd = "curl --connect-timeout 1 -sf ${static_url} -o ${filename}"
  }

  exec { "update_error_page_${title}":
    command => $cmd,
    unless  => "find ${filename} -mmin -360 -print 2>/dev/null | grep -Eqs '^${filename}$'",
    user    => 'deploy',
    group   => 'deploy',
    require => Class['curl'],
  }

}
