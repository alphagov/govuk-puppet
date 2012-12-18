# This is not the redirector app, it handles redirects from alphagov to GOV.UK
class govuk_node::redirect_server inherits govuk_node::base {
  include nginx
  nginx::config::vhost::redirect {
    'gov.uk':
      certtype => 'www',
      to       => 'https://www.gov.uk/';
    'blog.alpha.gov.uk': # FIXME ssl cert?
      to => 'http://digital.cabinetoffice.gov.uk/';
    'alpha.gov.uk': # FIXME ssl cert?
      to => 'http://webarchive.nationalarchives.gov.uk/20111004104716/http://alpha.gov.uk/';
  }
}
