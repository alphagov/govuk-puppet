class govuk::node::whitehall_frontend_server inherits govuk::node::base {
  include govuk::node::ruby_app_server
  include nginx

  $app_domain = extlookup('app_domain')

  nginx::config::vhost::redirect { "whitehall.${app_domain}":
    to => "https://whitehall-frontend.${app_domain}/",
  }

  include govuk::apps::whitehall_frontend
}
