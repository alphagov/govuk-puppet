# Creates the isabelllong user - temporarily - so we can remove their home dir
class users::isabelllong {
  govuk_user { 'isabelllong':
    ensure   => absent,
  }
}
