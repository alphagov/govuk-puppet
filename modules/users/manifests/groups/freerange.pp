class users::groups::freerange {

  govuk::user { 'jasoncale': ensure => absent }

  govuk::user { 'tomw':
    ensure     => absent,
    fullname   => 'Tom Ward',
    email      => 'tom.ward@gofreerange.co.uk',
  }
  govuk::user { 'chrisroos':
    ensure     => absent,
    fullname   => 'Chris Roos',
    email      => 'chris.roos@gofreerange.com';
  }
  govuk::user { 'jamesmead':
    ensure     => absent,
    fullname   => 'James Mead',
    email      => 'james@floehopper.org';
  }
  govuk::user { 'lazyatom':
    ensure     => absent,
    fullname   => 'James Adam',
    email      => 'james.adam@gofreerange.com';
  }

}
