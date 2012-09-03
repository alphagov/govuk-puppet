# This is not the redirector app, it handles redirects from alphagov to GOV.UK
class govuk_node::redirect_server inherits govuk_node::base {
  class { 'nginx': node_type => redirect }
}
