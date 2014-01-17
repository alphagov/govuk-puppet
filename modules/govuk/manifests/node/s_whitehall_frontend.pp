class govuk::node::s_whitehall_frontend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server
  include nginx

  # Java needed for tika
  include java::oracle7::jdk
  include java::oracle7::jre

  class { 'java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  $app_domain = extlookup('app_domain')
  $protect_fe = str2bool(extlookup('protect_frontend_apps', 'no'))


  nginx::config::vhost::redirect { "whitehall.${app_domain}":
    to => "https://whitehall-frontend.${app_domain}/",
  }

  class { 'govuk::apps::whitehall':
    configure_frontend     => true,
    vhost_protected        => $protect_fe,
    vhost                  => 'whitehall-frontend',
    # 10GB for a warning
    nagios_memory_warning  => 10737418240,
    # 12GB for a critical
    nagios_memory_critical => 12884901888,
  }
}
