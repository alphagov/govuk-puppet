class govuk::node::s_licensify_frontend (
  #FIXME #73421574: remove when we are off old preview and it is no longer possible
  #       to access apps directly from the internet
  $app_basic_auth = false
) inherits govuk::node::s_base {
  include clamav

  include govuk_java::oracle7::jdk

  class { 'nginx': }
  class { 'licensify::apps::licensify':
    vhost_protected => $app_basic_auth;
  }
  class { 'licensify::apps::licensing_web_forms': }
}
