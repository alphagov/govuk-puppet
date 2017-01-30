# Creates the davidhenry user
class users::davidhenry {
  govuk_user { 'davidhenry':
    fullname => 'David Henry',
    email    => 'david.henry@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdU0tFa7DorZGCG5Gzye1dv4ipWLc/1bcdbQCtD5NDmJlZVAZNjGUx1cwaet2nWKe5KJqbhC/F6F5z5PhTGiNqUsUrAcP4GcSycRidc5OqgfCGQGJbdGONMYPltLyx+iFU8RcSSjpMz7YxINeqBUptFISZBBXd4wj8c81pkOGhy7EdhLk06l80jKg+u4PnRDbNP9HjTH/qcGoJhcUBXkPSnNWY6dtqzZCXhq/qAkBWGy4StLLbfg05pnZ6kJW4mzx9I1PACX1graLipbuJHWrBRK6MM+F2Ozu7IikU+D6OpqUL5fhACR7ykkvTf8B8Wt1eoep4PCv/S0UEeDyBIrPJWF4an+ogRMfJrCKgaD8QbDrishzpo1N4lR05oi7mSXYDV5mGgpj03KJ3d5clmi9RtCE7HCLbCA5V0hW6PTnp/Z1lNWXs4lZAJm+CstnZOSMqbGQounkmYm+3WaYKkZoK4vuJbMOjf5ZKyporKVQjvIgUI7M3nkQGgGoOnAQTjS5T13Ii6XT6sv+1Zdlxg4GE46KEghDunQlPBiiw3PI1kh6yM1QaxAKfHlpRA5YGcelorGlHBBmhengx8aiD3KHaEXUW/IRNUPDu8sm9BLSUX7gQ5y9QWyPedKNI8PgDqpdYerJx0gUuCImqbO1LW8bntrHnv8v4bROz3AcA+S27MQ== david@becoybecoy.com',
  }
}
