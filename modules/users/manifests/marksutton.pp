# Creates the marksutton user - temporarily - so we can remove their home dir
class users::marksutton {
  govuk_user { 'marksutton':
    ensure   => absent,
  }
}
