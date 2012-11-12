define nginx::config::vhost::default(
  $extra_config = '',
  $status = '500',
  $status_message = "'{\"error\": \"Fell through to default vhost\"}\\n'",
  $ssl_certtype = 'wildcard_alphagov'
) {

  nginx::config::ssl { $title:
    certtype => $ssl_certtype,
  }

  nginx::config::site { $title:
    content => template('nginx/default-vhost.conf'),
  }

}
