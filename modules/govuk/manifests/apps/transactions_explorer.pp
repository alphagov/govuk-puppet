# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::transactions_explorer {
  $app_domain = hiera('app_domain')
  $app_name = 'transactions-explorer'
  $vhost_full = "${app_name}.${app_domain}"
  $app_path = "/data/vhost/${app_name}"

  $te_root = "${app_name}.${app_domain}"
  $website_root = hiera('website_root')

  $logpath = '/var/log/nginx'
  $access_log = "${vhost_full}-access.log"
  $json_access_log = "${vhost_full}-json.event.access.log"
  $error_log = "${vhost_full}-error.log"

  # Whether to enable SSL. Used by template.
  $enable_ssl = hiera('nginx_enable_ssl', true)
  # Whether to enable basic auth protection. Used by template.
  $enable_basic_auth = hiera('nginx_enable_basic_auth', true)

  include govuk::deploy

  govuk::app::package { $app_name:
    vhost_full => $vhost_full,
  }

  nginx::config::ssl {$vhost_full:
    certtype => 'wildcard_alphagov',
  }
  nginx::config::site { $te_root:
    content => template('nginx/transactions-explorer-vhost.conf'),
  }
}
