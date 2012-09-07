class govuk_node::mirror_server inherits govuk_node::base {
  include nginx
  nginx::config::vhost::mirror { 'www.gov.uk': certtype => 'www'}
  include mirror
}
