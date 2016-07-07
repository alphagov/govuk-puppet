# == Define: nginx::config::vhost::redirect
#
# Create a simple Nginx HTTP and HTTPS vhost which redirects all requests to
# another location.
#
# === Parameters
#
# [*to*]
#   Location to redirect to. A 301 permanent redirect will be issued and the
#   query path of the original request will be appended. You probably want
#   this to be an absolute URL starting with `http://` or `https://`
#   otherwise you'll generate an infinite loop.
#
# [*certtype*]
#   The "type" of cert to use. See `nginx::config::ssl`.
#   Default: wildcard_publishing
#
define nginx::config::vhost::redirect($to, $certtype = 'wildcard_publishing') {
  nginx::config::site { $name:
    content => template('nginx/redirect-vhost.conf'),
  }
  nginx::config::ssl { $name: certtype => $certtype }
}
