# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::external_link_tracker (
  $enabled = true,
  $mongodb_nodes,
  $port = '3066',
  $api_port = 3067,
  $api_healthcheck = '/healthcheck',
  $error_log = '/var/log/external-link-tracker/errors.json.log',
) {
  if $enabled {
    govuk::app { 'external-link-tracker':
      ensure             => absent,
      app_type           => 'bare',
      command            => './external-link-tracker',
      port               => $port,
      enable_nginx_vhost => true,
    }

    $app_domain = hiera('app_domain')
    $full_domain = "api-external-link-tracker.${app_domain}"

    nginx::config::vhost::proxy { $full_domain:
      ensure    => absent,
      to        => ["localhost:${api_port}"],
      protected => false,
      ssl_only  => false,
    }

    govuk::logstream { 'external-link-tracker-error-json-log':
      ensure  => absent,
      logfile => $error_log,
      tags    => ['error'],
      fields  => {'application' => 'external-link-tracker'},
      json    => true,
    }
  }
}
