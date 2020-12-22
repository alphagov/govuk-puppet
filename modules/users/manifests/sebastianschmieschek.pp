# Creates the sebastianschmieschek user - temporarily - so we can remove their home dir
class users::sebastianschmieschek {
  govuk_user { 'sebastianschmieschek':
    ensure   => absent,
  }
}
