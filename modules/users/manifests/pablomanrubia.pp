# Creates the pmanrubia user
class users::pablomanrubia {
  govuk_user { 'pablomanrubia':
    fullname => 'Pablo Manrubia',
    email    => 'pablo.manrubia@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3PKHtL85jIXCpzP+A9AvhyscYkDq4dKJbG1e6QDbS9BwbRjH6McVeuJIJ2nxsEEoz7KmOJgaTt+yFJS6BYYRd8GmczbEboWD1EUk01+eymBFYCP2ircqaOrDQw2FW4uS3EE6nPFqg0YKkUr+p85mGt/0/OnEaqnzhpOZEWnVvbIE/nLiO6XCmsgQgrjC8S9vr0O4aFgyi03rcdty3ebsE+OZqtvCqPMP55uiykrVoqYis5uJraVBtp+d2znSsM5vyfZHQgtzhQDiJYljkvZa83a1KDjkFmxm78SeiFMsd9GaF5+5ZjFNFTRd+jv62/K4y0D08+Gb24DoBv0p33zml3UHrrsqNxXtuQg+9zGxIepr2+NnZwr/ktpFfz8jNUpvw3ypZiQugUTFqxALXQL5foR3Mkf5R2Gda7IYTc/peJNaBV4a00yxmDtUt1ScGCq24d8Fy38rw9a4JLqBvxT8z+TqD9TSIIsVP0hns0HjP9wGnrwcFMKREMVscl2/OWSktj04dDIgMHMy1ytRzAZIPG76wrNX8ExoDKYxtXqK25aBRvTVThQZK1BAvWoEMPPk2X/zoPolCB0BedBucCZPtWPEkglf2UDjrPLUWsgDtDoPoVuavXCY8ZCexyNxKG1W3walrkkL4Zy06gTMExlElXQMNXkOzVhYlSFJysfpPpw== pmanrubia@gmail.com',
  }
}
