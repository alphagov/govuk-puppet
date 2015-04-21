# == Class: govuk::apps::performanceplatform_big_screen_view
#
# Big screen view displays a view of dashboards on the performance platform
# optimised for big screens
#
# === Parameters
class govuk::apps::performanceplatform_big_screen_view (
  $enabled = false,
) {
  include govuk::deploy

  if $enabled {
    $app_domain = hiera('app_domain')
    $app_name = 'performanceplatform-big-screen-view'
    $vhost_full = "${app_name}.${app_domain}"
    govuk::app::package { $app_name:
      ensure     => present,
      vhost_full => $vhost_full,
    }
    govuk::app::nginx_vhost { $app_name:
      ensure     => present,
      static_app => true,
      vhost      => $vhost_full,
      ssl_only   => true,
      app_port   => 3058,
    }
  }
}
