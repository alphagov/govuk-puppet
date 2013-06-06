class govuk::apps::search( $port = 3009 ) {
  govuk::app { 'search':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/mainstream/search?q=search_healthcheck',
  }

  # For generating spelling suggestions
  package { ['aspell', 'aspell-en', 'libaspell-dev']:
    ensure => installed,
  }
}
