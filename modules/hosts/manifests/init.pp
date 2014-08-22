# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class hosts {
  include ::hosts::default
  include ::hosts::production

  # This must be included AFTER hosts::production
  include ::hosts::purge
}
