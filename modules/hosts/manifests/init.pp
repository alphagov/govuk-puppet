class hosts {
  include ::hosts::default
  include ::hosts::production

  # This must be included AFTER hosts::production
  include ::hosts::purge
}
