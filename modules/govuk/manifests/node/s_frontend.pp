class govuk::node::s_frontend inherits govuk::node::s_base {

  $protect_fe = str2bool(extlookup('protect_frontend_apps', 'no'))

  include govuk::node::s_ruby_app_server

  class {
    'govuk::apps::businesssupportfinder': vhost_protected => $protect_fe;
    'govuk::apps::calendars':             vhost_protected => $protect_fe;
    'govuk::apps::datainsight_frontend':  vhost_protected => $protect_fe;
    'govuk::apps::designprinciples':      vhost_protected => $protect_fe;
    'govuk::apps::feedback':              vhost_protected => $protect_fe;
    'govuk::apps::frontend':              vhost_protected => $protect_fe;
    'govuk::apps::licencefinder':         vhost_protected => $protect_fe;
    'govuk::apps::limelight':             vhost_protected => true;
    'govuk::apps::smartanswers':          vhost_protected => $protect_fe;
    'govuk::apps::tariff':                vhost_protected => $protect_fe;
  }

  if str2bool(extlookup('govuk_enable_transaction_wrappers', 'no')) {
    class {
      'govuk::apps::transaction_wrappers':  vhost_protected => $protect_fe;
    }
  }

  if str2bool(extlookup('govuk_enable_tariff_demo', 'no')) {
    class {
      'govuk::apps::tariff_demo':           vhost_protected => $protect_fe;
    }
  }

  include govuk::apps::canary_frontend
  include govuk::apps::publicapi #FIXME to be removed when we ditch ec2 -- ppotter 2012-10-12
  include govuk::apps::static

  case $::govuk_provider {
    'sky':   {}
    default: {
      include govuk::apps::efg
    }
  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }
}
