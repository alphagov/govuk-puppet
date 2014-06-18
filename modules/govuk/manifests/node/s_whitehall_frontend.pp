class govuk::node::s_whitehall_frontend (
  #FIXME #73421574: remove when we are off old preview and it is no longer possible
  #       to access apps directly from the internet
  $app_basic_auth = false
) inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server
  include nginx

  # Java needed for tika
  include govuk_java::oracle7::jdk
  include govuk_java::oracle7::jre

  class { 'govuk_java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  $app_domain = hiera('app_domain')

  nginx::config::vhost::redirect { "whitehall.${app_domain}":
    to => "https://whitehall-frontend.${app_domain}/",
  }

  class { 'govuk::apps::whitehall':
    configure_frontend     => true,
    vhost_protected        => $app_basic_auth,
    vhost                  => 'whitehall-frontend',
    # 10GB for a warning
    nagios_memory_warning  => 10737418240,
    # 12GB for a critical
    nagios_memory_critical => 12884901888,
  }
}
