class mapit::nginx {
  include ::nginx

  nginx::config::ssl { 'wildcard_alphagov':
    certtype => 'wildcard_alphagov'
  }

  nginx::config::site { 'mapit':
    source  => 'puppet:///modules/mapit/nginx_mapit.conf'
  }

  nginx::log {
    'mapit.json.event.access.log':
      json      => true,
      logstream => true;
    'mapit.access.log':
      logstream => false;
    'mapit.error.log':
      logstream => true;
  }
}
