class hosts::ertp {
  case $::govuk_platform {
    staging:    { include hosts::ertp-staging }
   	default:    { include hosts::ertp-preview }
  }
}
