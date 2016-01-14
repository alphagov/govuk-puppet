# Creates the simonhughesdon user
class users::simonhughesdon {
  govuk::user { 'simonhughesdon':
    fullname => 'Simon Hughesdon',
    email    => 'simon.hughesdon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDB7cgSjw2o0PiPuq9m8UMrj5k53NoTyZ+JSzPzZdgRO+v+VTgkOAvcSdPcd+eAob1UBTKNzCAxzvs+SCzmIxczun5eqzUtQvgWWZvXkKV4a9oezqWjK3pG/4x+LVOSt5vmIlHaYfYfJ51lh4VaWVSbRU+aQBhZmicUZrF6c6qCelpmL0Br/kqJM3cH9y3j6IVPMlry1f1YSJ+1LGrsfXIJIkOD5LjkTISm7Khp2qa27UxLvyEDPpJtJegybylgeCcPzl9CPm52ltgjLc51fbTMagxWNGkTX7nUizIDlC8/hvaz73jX7aeA6W5Cabsw8qEwXYEWOjCTch7iKbfEQCNrrH13fHycAUPcV047B1kvKYTo6fS9g6OIl948DY5I9ZEOTAfRgUUU/ES8wPdX4kItM2bjhUNNmJcViXGC725OmbTNsu0DHbfbuVOi3bx4xpcs9VYmVyhoEJY1SNAREwmjh6kBHQ3ScGLq/mSJ5UGcmXDzxMuRQJ807T63MOiEPqvLEwRxnkLsByL0NY9oSe9S6aW/DrQQhQ9qAln/eg0OrKQQix4OphP5pflOYlxNK+IRmPPpkxShcK+73H1U7or39MA9TVxSuSgua9WPANVhv67sGVYk61Z3xPvTyadHm87kEcwpU2BtIU8YIbV7fdphEFnOAih7o6iOE9TXrJAQyw== simon.hughesdon@digital.cabinet-office.gov.uk',
  }
}
