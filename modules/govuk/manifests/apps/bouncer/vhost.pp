# == Define: govuk::apps::bouncer::vhost
#
# This allows you to create an nginx virtual host for a list of host names,
# with a given document root which will be used to serve requests before
# falling back to the app. Additionally, custom location rules can be specified
# for other behaviours.
#
# This enables us to provide behaviours we need for these sites in Bouncer so
# that we can migrate them from Redirector.
#
# === Parameters
#
# [*server_names*]
#   An array of server_names that the vhost relates to.
#
# [*document_root*]
#   A string path to the directory that should be used when serving files on
#   this vhost.
#
# [*custom_location_rules*]
#   An optional hash of location URI mapping to the directive that should be
#   applied to matching requests.
#
# === Examples
#
# Example usage:
#
#   govuk::apps::bouncer::vhost { 'businesslink_lrc':
#     server_names => [
#       'lrc.businesslink.gov.uk',
#     ],
#     document_root => '/var/apps/bouncer/assets-businesslink/businesslink',
#     custom_location_rules => {
#       '/lrc/lrcHeader' => 'try_files /xgovsnl/images/ecawater/wtlproducts/bl1000/logo_nonjava.jpg @app'
#     }
#   }
#
define govuk::apps::bouncer::vhost(
  $server_names,
  $document_root,
  $custom_location_rules = {},
) {

  nginx::config::site { $title:
    content => template('bouncer/vhost.conf.erb'),
  }

  nginx::log {
    "${title}-json.event.access.log":
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.${title}.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_underscore}.nginx_logs.${title}.time_request",
                          value => '@fields.request_time'}];
    "${title}-error.log":
      logstream     => present;
  }
}
