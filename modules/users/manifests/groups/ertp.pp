class users::groups::ertp {

  govuk::user { 'jameshu':
    fullname   => 'James Hughes',
    email      => 'j.hughes@kainos.com';
  }
  govuk::user { 'michaela':
    fullname   => 'Michael Allen',
    email      => 'm.allen@kainos.com';
  }
  govuk::user { 'leszekg':
    fullname   => 'Leszek Gonczar',
    email      => 'l.gonczar@kainos.com';
  }

}
