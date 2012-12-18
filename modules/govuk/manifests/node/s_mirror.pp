class govuk::node::s_mirror inherits govuk::node::s_base {
  include nginx
  nginx::config::vhost::mirror { 'www.gov.uk': certtype => 'www'}
  include mirror
}
