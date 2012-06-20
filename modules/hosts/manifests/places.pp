class hosts::places {
  case $::govuk_platform {
    staging: { include hosts::places-staging }
    default: { include hosts::places-preview }
  }
}
