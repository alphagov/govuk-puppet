class hosts {
  include ::hosts::default

  case $::govuk_provider {
    sky: {
      include hosts::skyscape::production_like
    }
    default: {
      include hosts::preview
    }
  }
}
