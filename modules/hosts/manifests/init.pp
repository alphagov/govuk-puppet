class hosts {
  case $::govuk_provider {
    sky: {
      case $::govuk_platform {
        production: { include hosts::skyscape::production_like }
        staging:    { include hosts::skyscape::production_like }
        default:    { include hosts::skyscape::production_like }
      }
    }
    scc: {
        include hosts::scc::production
    }
    default: {
      case $::govuk_platform {
        production: { include hosts::production }
        preview:    { include hosts::preview }
        default:    { include hosts::development }
      }
    }
  }
}
