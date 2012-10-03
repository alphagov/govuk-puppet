class users::groups::other {

  govuk::user { 'tomstuart':
    fullname   => 'Tom Stuart',
    email      => 'tom@experthuman.com';
  }

  govuk::user { 'chrismdp':
    fullname => 'Chris Parsons',
    email    => 'chris@thinkcodelearn.com';
  }

}
