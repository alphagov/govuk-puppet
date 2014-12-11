# == Class: govuk_heka::nginx
#
# Consume all Nginx error entries.
#
class govuk_heka::nginx {
  # FIXME: Move this to a global config option in heka >=0.9
  if !$::fqdn_underscore {
    fail('Unable to load `fqdn_underscore` fact')
  }

  heka::plugin { 'nginx':
    content => template('govuk_heka/etc/heka/nginx.toml.erb'),
  }
}
