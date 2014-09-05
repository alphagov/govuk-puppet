# Installs this Icinga plugin. Can be included multiple times.
class icinga::plugin::check_http_timeout_noncrit {
    icinga::plugin { 'check_http_timeout_noncrit':
        source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_http_timeout_noncrit',
    }
}
