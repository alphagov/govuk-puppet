# == Class: monitoring::checks::fastly
#
# Nagios alerts for fastly error rates.
#
# === Variables:
#
# [*fastly_enable_checks*]
#   Can be used to disable checks/alerts for a given environment.
#   Default: yes
#
class monitoring::checks::fastly {

    # FIXME: Remove when deployed.
    icinga::plugin { 'check_fastly_error_rate':
      ensure => absent,
    }

    $fastly_enable_checks      = str2bool(extlookup('fastly_checks', 'no'))

    if $fastly_enable_checks {

        $fastly_api_key            = extlookup('fastly_api_key', '')
        $fastly_assets_service     = extlookup('fastly_assets_service', '')
        $fastly_govuk_service      = extlookup('fastly_govuk_service', '')
        $fastly_redirector_service = extlookup('fastly_redirector_service', '')

        class { 'collectd::plugin::cdn_fastly':
          api_key        => $fastly_api_key,
          services       => {
            'govuk'      => $fastly_govuk_service,
            'assets'     => $fastly_assets_service,
            'redirector' => $fastly_redirector_service,
          },
        }

    }

}
