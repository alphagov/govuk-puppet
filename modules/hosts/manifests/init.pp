class hosts {
  case $::govuk_platform {
    production: { include hosts::production }
    preview:    { include hosts::preview }
    default:    { include hosts::development }
  }
}
