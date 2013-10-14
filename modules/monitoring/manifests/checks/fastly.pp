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

    file{'/usr/lib/nagios/plugins/check_fastly_error_rate':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_fastly_error_rate'
    }

    file{'/etc/nagios3/conf.d/check_fastly_error_rate.cfg':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_fastly_error_rate.cfg',
        require => File['/usr/lib/nagios/plugins/check_fastly_error_rate'],
    }

    $fastly_enable_checks      = str2bool(extlookup('fastly_checks', 'no'))

    if $fastly_enable_checks {

        $fastly_api_key            = extlookup('fastly_api_key', '')
        $fastly_assets_service     = extlookup('fastly_assets_service', '')
        $fastly_govuk_service      = extlookup('fastly_govuk_service', '')
        $fastly_redirector_service = extlookup('fastly_redirector_service', '')

        nagios::check { 'check_fastly_asset_errors':
            check_command       => "check_fastly_error_rate!${fastly_assets_service}!${fastly_api_key}!1!2",
            use                 => 'govuk_regular_service',
            host_name           => $::fqdn,
            service_description => 'Check asset CDN error rate',
            require             => File['/etc/nagios3/conf.d/check_fastly_error_rate.cfg']
        }

        nagios::check { 'check_fastly_govuk_errors':
            check_command       => "check_fastly_error_rate!${fastly_govuk_service}!${fastly_api_key}!2!5",
            use                 => 'govuk_regular_service',
            host_name           => $::fqdn,
            service_description => 'Check GOV.UK CDN error rate',
            require             => File['/etc/nagios3/conf.d/check_fastly_error_rate.cfg']
        }

        nagios::check { 'check_fastly_redirector_errors':
            check_command       => "check_fastly_error_rate!${fastly_redirector_service}!${fastly_api_key}!2!5",
            use                 => 'govuk_regular_service',
            host_name           => $::fqdn,
            service_description => 'Check redirector CDN error rate',
            require             => File['/etc/nagios3/conf.d/check_fastly_error_rate.cfg']
        }

    }

}
