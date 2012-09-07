define nginx::config::vhost::redirect($to, $certtype = 'wildcard_alphagov') {
  nginx::config::site { $name:
    content => template('nginx/redirect-vhost.conf'),
  }
  nginx::config::ssl { $name: certtype => $certtype }
}
