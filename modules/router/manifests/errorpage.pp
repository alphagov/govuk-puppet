define router::errorpage () {
  exec {"update_error_page_${title}":
    command => "curl -f https://static.${::govuk_platform}.alphagov.co.uk/templates/${title}.html.erb -o /usr/share/nginx/www/${title}.html",
    user    => 'deploy',
    group   => 'deploy',
  }
}
