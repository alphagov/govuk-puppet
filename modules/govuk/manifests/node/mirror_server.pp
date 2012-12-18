class govuk::node::mirror_server inherits govuk::node::base {
  include nginx
  nginx::config::vhost::mirror { 'www.gov.uk': certtype => 'www'}
  include mirror
}
