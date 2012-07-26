class users::groups::freerange {

  govuk::user { 'jasoncale': ensure => absent }

  govuk::user { 'tomw':
    fullname   => 'Tom Ward',
    email      => 'tom.ward@gofreerange.co.uk',
    shell      => '/bin/zsh';
  }
  govuk::user { 'chrisroos':
    fullname   => 'Chris Roos',
    email      => 'chris.roos@gofreerange.com';
  }
  govuk::user { 'jamesmead':
    fullname   => 'James Mead',
    email      => 'james@floehopper.org';
  }
  govuk::user { 'lazyatom':
    fullname   => 'James Adam',
    email      => 'james.adam@gofreerange.com';
  }

}
