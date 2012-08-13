class hosts {
  case $::govuk_provider {
    sky: {
      case $::govuk_platform {
        production: { include hosts::skyscape::production }
        default:    { include hosts::skyscape::production }
      }
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
