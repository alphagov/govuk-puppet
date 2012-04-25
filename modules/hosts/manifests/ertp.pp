class hosts::ertp {
  case $::govuk_platform {
    default:    { include hosts::ertp-preview }
  }
}
