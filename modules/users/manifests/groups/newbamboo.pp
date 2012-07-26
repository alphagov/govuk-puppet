class users::groups::newbamboo {

  govuk::user { 'benp':
    fullname   => 'Ben Pickles',
    email      => 'ben@new-bamboo.co.uk';
  }
  govuk::user { 'niallm':
    fullname   => 'Niall Mullally',
    email      => 'naill@new-bamboo.co.uk';
  }
  govuk::user { 'ollyl':
    fullname   => 'Olly Legg',
    email      => 'olly@new-bamboo.co.uk';
  }

}
