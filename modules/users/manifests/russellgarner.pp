# Creates the russellgarner user
class users::russellgarner {
  #Once PR has been merged delete this file
  govuk_user { 'russellgarner':
    ensure   => absent,
    fullname => 'Russell Garner',
    email    => 'russell.garner@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/STrmC2xPJ+62xFjjIn38T88Z7PG7OXBWnZww8P8JpW5T3KLQ//LSiiFDrJDkwT5ZZlUOY9db1u/kSBU1HFP34fnn8pTSOm45IKJDAdXKdrDv2FDJSG13hRXS/9Lpoi0y3p+IWo07kx5l1+QmigyfafwyMQ7wbHIZlFz+FvkBEH1VFVxFUdzFzJViFwPMLNiz9hSJ8DiNjw1ZTN1uZsnmMQeg0pFr9LvbvJvg8upBKmydzsnSInJawH4+9KXll/lDlp5ZLeiS/5ZmP7/QkTgyN/g25gTIT8skoKbi4lIgkoFJb73JwZ+PDgqDdwe594YksZ1yb7pxNPz6tpacL+MHcKc2Hb1oHBybAgL+8aPyRKKbP+qt9XW3854ycRADvYSELIG5j26lnBSszRkwe0jRFPzMR82jIB6hizGPZizQhs83RyvPaiKeXyDJQVJCDDFPe/27KKBJFLHNRQzX+utOJ422NfOe1Y1p6z8mCyppla53ghjcV3qubQ7Fb9ZlKZhksmDmMvPeOoas7uT2fVbdtNC6wmFTnZeiaiD5pNMY/QpBxoFx0dd4Rk6jmKpkpl+GuAlVXnUMvyugNnw0Ue6lLxxdTBRB7FNamyR1DNGgR+uDdA2sOzKxou22+f2F9RiJsxviVDzGIO86IS+NKMYgY18x2FDNJhgCcrR4tIUBKw== rgarner@zephyros-systems.co.uk',
  }
}
