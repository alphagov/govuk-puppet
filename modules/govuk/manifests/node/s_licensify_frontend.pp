# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_licensify_frontend inherits govuk::node::s_base {
  include clamav

  include govuk_java::oracle7::jdk

  include nginx
  include licensify::apps::licensify
  include licensify::apps::licensing_web_forms
}
