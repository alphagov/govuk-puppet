class hosts::ertp {
  case $::govuk_platform {
    staging: { include hosts::ertp_staging }
    default: { include hosts::ertp_preview }
  }
}
