# Creates the chrisfarmiloe user - temporarily - so we can remove their home dir
class users::chrisfarmiloe {
  govuk_user { 'chrisfarmiloe':
    ensure   => absent,
  }
}
