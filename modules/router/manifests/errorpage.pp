define router::errorpage () {

  $app_domain = extlookup('app_domain')

  exec {"update_error_page_${title}":
    command => "curl -sf https://static.${app_domain}/templates/${title}.html.erb -o /usr/share/nginx/www/${title}.html",
    user    => 'deploy',
    group   => 'deploy',
  }

}
