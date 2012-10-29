class hosts::places {
  case $::govuk_platform {
    staging: { include hosts::places_staging }
    default: { include hosts::places_preview }
  }
}
