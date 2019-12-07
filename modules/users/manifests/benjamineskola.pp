# Creates the benjamineskola user
class users::benjamineskola {
  govuk_user { 'benjamineskola':
    ensure   => absent,
    fullname => 'Benjamin Eskola',
    email    => 'benjamin.eskola@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCj6F9z60pBD0LROwUekfnNp55Gn1fSrGeSNuoJJoSSzqY1GsevT380YTphaM+L9Ig01S/oGgAxvWqXrLEDs0RYMT9ltYVmnz5ViSaEe+OI+oozkspmCRmjJjdOReunMJVyor5iZ5YNbl0Gl2frJ4AtoEDSijVhD2CtU4j5XxPWRyZZ0whe5TOCupVs7bBYmsGaumwPvaXoR4pZXkHPe7+PLur+U3EA880cY4XbMeWtS6vNVYfpSkMip1MgGvb308Tn4MizeuQCd3Pd+wMfz1ITYEOX9NQDd3DHQrLUv4tt4U0NGnaMHEr0ELg263FgkFDm29Cmex8z1sHn9qjlRA/Z1b82dnipojq7I3jF40EhFR60pRLIj+PpvsxBiVsGQWLxB/QJgaAMsi/sMYoTFdAPJ4f4DcUmvrXiG7lQi64zB5bOnYcqS9yZQY+fIDgYsIAMkZH6HsUOH4n83KaIHesWw+msRAgWB81S7pbjWePQ1RhxXCYYwgjRLE2uZyQ8gNljQMX+u8Vbf1rsPl08HWJOzyEXntyiuMqU7OTFjZlO78TLOd0CYmfGy8QDiLY84qZ98i9upQtuXioMwjhLJASTq+aMnKJFRXDLQ2p4Dry+FvBAmF5RorVpVzKZDCkUswigeKl/8sPZIt+EjKQTy73XNRS8PFKhE1aWRco9ICziOw== benjamin.eskola@digital.cabinet-office.gov.uk',
  }
}
