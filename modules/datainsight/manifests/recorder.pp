define datainsight::recorder($port, $platform = $::govuk_platform) {

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

  govuk::app { "datainsight-${title}-recorder":
    app_type => 'rack',
    port     => $port,
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    },
  }

  govuk::app { "datainsight-${title}-recorder-listener":
    app_type           => 'procfile',
    port               => 'UNUSED',
    enable_nginx_vhost => false,
    vhost_protected => $::govuk_provider ? {
      /sky|scc/ => false,
      default   => true
    },
  }

  file { "/data/vhost/datainsight-${title}-recorder-listener.${domain}/current":
    ensure  => link,
    target  => "/data/vhost/datainsight-${title}-recorder.${domain}/current",
    require => File["/data/vhost/datainsight-${title}-recorder-listener.${domain}"],
  }

}
