# Creates the ssatish user
class users::seemasatish {
  govuk::user { 'seemasatish':
    fullname => 'Seema Satish',
    email    => 'seema.satish@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcXWH60RKqGXSXkFBzl/Ram4PveXNG9snwlpURlbAEJ0pLOkp96cKBXYp4vNypfiEWNsN3bpH8nMEBZ5VfWEOyj9naYyNmW5wKePmhquzPxrgrrncW55gIf++4Bic9GDmLHUyrWhfOmmHimPpO0my1+reU/jlD+3eOJxL1IXWCP0OQpgNEzrBaZatlgHibcIkGT1rnWE84Vyzvd1lm7Nw2yZD4taENR4Tn9gjBmp8WgXaWegYEW2T+mbgQ5WXXELC0JpNH0asnL/glYX/qcSHqCxgDfHjJpu4EsY69RxnQy+Aa66tIFV3cFJ8Fhj/azY3c7+HKJf7Gwz2ckWbMOmjl ssatish@eussatish.local',
  }
}
