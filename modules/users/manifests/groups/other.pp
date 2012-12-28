class users::groups::other {

  govuk::user { 'tomstuart':
    fullname   => 'Tom Stuart',
    email      => 'tom@experthuman.com';
  }

  govuk::user { 'chrismdp':
    fullname => 'Chris Parsons',
    email    => 'chris@thinkcodelearn.com';
  }

  govuk::user { 'murraysteele':
    fullname => 'Murray Steele',
    email    => 'murray.steele@digital.cabinet-office.gov.uk';
  }

}
