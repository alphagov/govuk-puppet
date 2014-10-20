# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::bouncer(
  $port = 3049,
  $vhost_protected = false
) {

  govuk::app { 'bouncer':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => false,
    health_check_path  => '/healthcheck',
    vhost_protected    => false,
    # Disable the default nginx config, as we need a custom
    # one to allow us to set up wildcard alias
    enable_nginx_vhost => false
  }

  include govuk_postgresql::client

  $app_domain = hiera('app_domain')

  # Nginx proxy config with wildcard alias
  govuk::app::nginx_vhost { 'bouncer':
    vhost            => "bouncer.${app_domain}",
    app_port         => $port,
    ssl_only         => false,
    is_default_vhost => true
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
    }
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
    }
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
}
