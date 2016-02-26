# Creates the stuartgale user
class users::stuartgale {
  govuk_user { 'stuartgale':
    fullname => 'Stuart Gale',
    email    => 'stuart.gale@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3VSG/wyLEbASHpGwY4os0PNfCRBCVj/w8NsXFuNC6JDA5Ylz33xKM6QXmsW7WcEXz+apCkyvHeHZvijY2ztzoxMr0FbidNuHK28CyO99rzL8uGMqYpHgIIk9Iro9OW5uuROvXvSqAP0pdXQtMQQf9BfYD0+bGNZUsyvQ9nZtbijJHzEz7qyWpLY0mvgTc9A2uSggd0G8AsgxOHD/hJxlZdwoqrNDbSkskqD2UlDFmizzAzbAdiK3KGFO0kaEI1M5WkIBalMtMyr6TjMLpgHmHiaa2ivSWFkRNaz9LUVmN+K6izlGUEY4ANekzn6PxzJkTfXq7pfgnMHPbEdcm/2CNv/CewxgsBrCx7P8wsNwi5JzuIfG9aaTFfztMfhweHyBadtT176Uo3IJaqMM8fcAVZQuZcfcdgU6yfa+8zpWaX994pWub6nuGOkdkrS50PgwwnkhtKymcOmjiVuwtqUZ1EDJWNyOyN/u4GjrK5rrz1Mcu1vZOsz5Dy6fdlvWkyHgZ/OGrDUd5CCfOW8f4NGYNec1b/FiXITkRwxvEdamXcVG+4W0+/yYthf7gZT1cJFj1ZF/B0j09qFuKBVh8aIBXOdFNdku3cBRW1/W4cxvRKZvXvnLV50u4YHt3jOTH8tQx78nj1s9MS0SgQNEbpmpIN4n8f0sjwKKPiSusrN9mEQ== stuart.gale@digital.cabinet-office.gov.uk
',
  }
}
