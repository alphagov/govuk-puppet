class govuk_node::whitehall_frontend_server inherits govuk_node::base {
  include govuk_node::ruby_app_server
  include nginx

  nginx::config::vhost::redirect {
    "whitehall.${::govuk_platform}.alphagov.co.uk":
      to => "https://whitehall-frontend.${::govuk_platform}.alphagov.co.uk/";
  }

  include govuk::apps::whitehall_frontend
}
