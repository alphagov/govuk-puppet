# == Class: licensify::apps
#
# Installs and manages the licensify applications
#
class licensify::apps {
  include licensify::apps::licensify
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed
}
