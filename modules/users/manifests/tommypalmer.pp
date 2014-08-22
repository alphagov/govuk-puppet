# Creates the tommypalmer user
class users::tommypalmer {
  govuk::user { 'tommypalmer':
    fullname => 'Tommy Palmer',
    email    => 'tommy.palmer@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQJdyu+xqnBnROc/omKIkw4BEuo4SdVX2i13envVuyz57smBKJlA6OwgHAdfjHiBgNDjKekuwurqTLXrcQTAE4PF3CzaguC7trwMs7GNOLF/Yj9m33jj1phsrrR/rgo82CwEj2j+RznabWtNP55KTv0Jcqqrdd+3ZvFg+d2cmKGd1x0LkXUdq2N5wW6uL6Re4KwJti8fIdS0A7btnXIUfUjW4OO7nZl5jA+SrMk2oIHsFkhTxovTXri53FTbapv9oGPmWs8kcMEAiCD3T0s52MqH6+SdTUTf56S1QZ6iB/87YEmuV2YY7DAm3r3CIESSCgstHx1tclDOsjU0FGfIUX',
  }
}
