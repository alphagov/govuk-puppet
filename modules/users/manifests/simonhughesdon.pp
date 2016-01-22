# Creates the simonhughesdon user
class users::simonhughesdon {
  govuk_user { 'simonhughesdon':
    fullname => 'Simon Hughesdon',
    email    => 'simon.hughesdon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqbi1IsUFv6YjnhLTHY3pDhhGpl1chm657LpUU8Y/I3/4pUmtXF4N8HGoch5Be3VZDYrhWy7m9uqu2A7vVGn3Feq4TIZn2+hZ33A715iN4LSsqR/ccuOaHazb485RKgKbycFFwZVe4bxpuxy8rhqfQ9GckhQO2BrN5ZFmZVSiQ0hxh6fkWPILfp/bxI64c7MTOXeWt0rqPXJF7MHPQv1r47OiTzggYu+dk5eGPi1PUrU0npt3R3J1+c9lj6bNLpYRN6Ko+CzrOFXwp+mhxdv/1WZnKMPYpVU2W+97eZdUk6mOw2qUvYXvugCzOeVBrkhjW1xEEfybgJ8ud6rC1a60Dz1sPLO1uwaPP+VzC2GuvPP3WSS66HouaJkcjTHwT2TsLv0T21R3rFpae8FVDS4L2fw08SjR/IOqw3ZN3OARomomJBk4sojHC5UEnzY1ZIilyUS+DD8mtXYyZABXGuTREvDHCSvW1rcEpY16JKXceY4aLRs2kYYAvJdtpo5zUhnRTPpQRF8smtR9xElFhNi2+76cX/718Hf22Yu4IsY6p+4tHeQKQMF6/kzJavTIq/g0BnA/fDFGtfj2wx5qDyMwFkieYppgX4eW6Hyxhn+tph2uN4ntvhq1+hI30mHv2bs1+tqJq5Ze97hSMBCwzKZGdJe0LyGukjP72arw2hBEYfw== simon.hughesdon@digital.cabinet-office.gov.uk',
  }
}
