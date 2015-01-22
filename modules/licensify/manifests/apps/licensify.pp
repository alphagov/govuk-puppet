# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps::licensify (
  $port = 9000,
  $aws_ses_access_key = '',
  $aws_ses_secret_key = '',
) inherits licensify::apps::base {

  govuk::app { 'licensify':
    app_type           => 'procfile',
    port               => $port,
    nginx_extra_config => template('licensify/nginx_extra'),
    health_check_path  => '/api/licences',
    require            => File['/etc/licensing'],
  }

  licensify::apps::envvars { 'licensify':
    app                => 'licensify',
    aws_ses_access_key => $aws_ses_access_key,
    aws_ses_secret_key => $aws_ses_secret_key,
  }

  licensify::build_clean { 'licensify': }

  $app_domain = hiera('app_domain')
  $vhost_name = "uploadlicence.${app_domain}"
  $log_basename = $vhost_name

  nginx::config::ssl { $vhost_name: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost_name: content => template('licensify/licensify-upload-vhost.conf') }

  @@icinga::check::graphite { "check_nginx_5xx_${vhost_name}_on_${::hostname}":
    target    => "sumSeries(transformNull(stats.counters.${::fqdn_underscore}.nginx.${log_basename}.http_5??.rate,0))",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => "${vhost_name} high nginx 5xx rate",
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html?highlight=nagios#nginx-5xx-rate-too-high-for-many-apps-boxes',
  }
}
