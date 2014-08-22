# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps {
  include licensify::apps::licensify
  include licensify::apps::licensify_admin
  include licensify::apps::licensify_feed
}
