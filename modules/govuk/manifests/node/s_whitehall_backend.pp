class govuk::node::s_whitehall_backend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server
  include nginx
  include java::oracle7::jdk
  include java::oracle7::jre

  class { 'java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  class { 'govuk::apps::whitehall':
    configure_admin => true,
    port            => 3026,
    vhost_protected => true,
    vhost           => 'whitehall-admin',
  }

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }
}
