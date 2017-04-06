# == Class: govuk::apps::bouncer
#
# A Rack-based redirector for sites which have moved to GOV.UK.
#
# == Parameters
#
# [*errbit_api_key*]
#   An API key to send exceptions to Errbit.
#
# [*port*]
#   The port on which Bouncer is served on.
#   Default: 3049
#
# [*db_username*]
#   The username to use in DATABASE_URL.
#
# [*db_password*]
#   The password to use in DATABASE_URL.
#
# [*db_hostname*]
#   The hostname to use in DATABASE_URL.
#
# [*db_name*]
#   The database name to use in DATABASE_URL.
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::bouncer(
  $errbit_api_key = '',
  $db_username = 'bouncer',
  $db_password = '',
  $db_hostname = '',
  $db_name = 'transition_production',
  $port = '3049',
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {

  Govuk::App::Envvar {
    app => 'bouncer',
  }

  govuk::app { 'bouncer':
    app_type               => 'rack',
    port                   => $port,
    vhost_ssl_only         => false,
    health_check_path      => '/healthcheck',
    # Disable the default nginx config, as we need a custom
    # one to allow us to set up wildcard alias
    enable_nginx_vhost     => false,
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

  include govuk_postgresql::client

  $app_domain = hiera('app_domain')

  # Nginx proxy config with wildcard alias
  govuk::app::nginx_vhost { 'bouncer':
    vhost            => "bouncer.${app_domain}",
    app_port         => $port,
    ssl_only         => false,
    is_default_vhost => true,
  }

  govuk::apps::bouncer::vhost { 'businesslink':
    server_names  => [
      'www.businesslink.gov.uk',
      'aka.businesslink.gov.uk',
      'businesslink.gov.uk',
      'online.businesslink.gov.uk',
      'www.online.businesslink.gov.uk',
      'www.businesslink.co.uk',
      'www.businesslink.org',
      'www.business.gov.uk',
      'alliance-leicestercommercialbank.businesslink.gov.uk',
      'aol.businesslink.gov.uk',
      'msn.businesslink.gov.uk',
      'sagestartup.businesslink.gov.uk',
      'simplybusiness.businesslink.gov.uk',
      'businesslink.redirector.dev.alphagov.co.uk',
      'businesslink.redirector.preview.alphagov.co.uk',
      'businesslink.redirector.production.alphagov.co.uk',
    ],
    document_root => '/var/apps/bouncer/assets-businesslink/businesslink',
  }

  govuk::apps::bouncer::vhost { 'businesslink_lrc':
    server_names          => [
      'lrc.businesslink.gov.uk',
      'aka-lrc.businesslink.gov.uk',
    ],
    document_root         => '/var/apps/bouncer/assets-businesslink/businesslink',
    custom_location_rules => {
      # Serve the businesslink masthead image for requests like:
      #   /lrc/lrcHeader?type=logo&xgovs9k=voa&xgovr3h=r2010
      '/lrc/lrcHeader' => 'try_files /xgovsnl/images/ecawater/wtlproducts/bl1000/logo_nonjava.jpg @app',
    },
  }

  govuk::apps::bouncer::vhost { 'businesslink_ukwelcomes':
    server_names          => [
      'upload.ukwelcomes.businesslink.gov.uk',
      'online.ukwelcomes.businesslink.gov.uk',
      'www.ukwelcomes.businesslink.gov.uk',
      'ukwelcomes.businesslink.gov.uk',
    ],
    document_root         => '/var/apps/bouncer/assets-businesslink/businesslink_ukwelcomes',
    custom_location_rules => {
      # We receive an HTTP POST at this URL at the end of a licensing
      # application. The Licensing app needs to receive these in order to record
      # an outcome for the payments/licensing application. Example request:
      # POST /eff/action/worldPayCallback?installation=254078&msgType=authResult
      # Receving a 200.
      #
      # We are working on getting each of the ~150 local councils to use the GOV.UK
      # URL directly, but this will take time.
      '/eff/action/worldPayCallback' => 'proxy_pass https://www.gov.uk/apply-for-a-licence/payment/worldpayCallback',
    },
  }

  govuk::apps::bouncer::vhost { 'directgov':
    server_names  => [
      'www.direct.gov.uk',
      'aka.direct.gov.uk',
      'resources.direct.gov.uk',
      'aka-resources.direct.gov.uk',
      '3g.direct.gov.uk',
      'aka-3g.direct.gov.uk',
      'imode.direct.gov.uk',
      'aka-imode.direct.gov.uk',
      'm.direct.gov.uk',
      'aka-m.direct.gov.uk',
      'mobile.direct.gov.uk',
      'aka-mobile.direct.gov.uk',
      'o2.direct.gov.uk',
      'aka-o2.direct.gov.uk',
      'wap.direct.gov.uk',
      'aka-wap.direct.gov.uk',
      'directgov.redirector.dev.alphagov.co.uk',
    ],
    document_root => '/var/apps/bouncer/assets-directgov/assets',
  }

  govuk::apps::bouncer::vhost { 'directgov_campaigns':
    server_names  => [
      'campaigns.direct.gov.uk',
      'aka-campaigns.direct.gov.uk',
      'www.campaigns.direct.gov.uk',
      'aka.campaigns.direct.gov.uk',
      'campaigns2.direct.gov.uk',
      'aka-campaigns2.direct.gov.uk',
      'directgov_campaigns.redirector.dev.alphagov.co.uk',
    ],
    document_root => '/var/apps/bouncer/assets-directgov/directgov_campaigns',
  }

  nginx::config::site {'www.mhra.gov.uk':
    content => template('bouncer/www.mhra.gov.uk_nginx.conf.erb'),
  }

  nginx::log {
    'www.mhra.gov.uk-json.event.access.log':
      json          => true,
      logstream     => present,
      statsd_metric => "${::fqdn_metrics}.nginx_logs.mhra_proxy.http_%{@fields.status}",
      statsd_timers => [{metric => "${::fqdn_metrics}.nginx_logs.mhra_proxy.time_request",
                          value => '@fields.request_time'}];
    'www.mhra.gov.uk-error.log':
      logstream     => present;
  }

  if $::govuk_node_class !~ /^(development|training)$/ {
    govuk::app::envvar::database_url { 'bouncer':
      type     => 'postgresql',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
  }
}
