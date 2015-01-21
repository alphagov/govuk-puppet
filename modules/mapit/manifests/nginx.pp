# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mapit::nginx {
  include ::nginx

  nginx::config::ssl { 'wildcard_alphagov':
    certtype => 'wildcard_alphagov'
  }

  nginx::config::site { 'mapit':
    source  => 'puppet:///modules/mapit/nginx_mapit.conf'
  }
}
