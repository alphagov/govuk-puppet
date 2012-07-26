class users::groups::opg {

  govuk::user { 'alister':
    fullname   => 'Alister Bulman',
    email      => 'alister.bulman@betransformative.com',
    has_deploy => false;
  }
  govuk::user { 'chrismo2012':
    fullname   => 'Chris Moreton',
    email      => 'chris.moreton@betransformative.com',
    has_deploy => false;
  }
  govuk::user { 'jamie':
    fullname   => 'jamie',
    email      => 'Jamie.Burns@betransformative.com',
    has_deploy => false;
  }

}
