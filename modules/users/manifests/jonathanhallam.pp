# Creates jonathanhallam user
class users::jonathanhallam {
  govuk_user { 'jonathanhallam':
    fullname => 'Jonathan Hallam',
    email    => 'jonathan.hallam@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbhuGtTqXfhGAJUREY8foyy522FQ9djFwYAat0QU2C8eg8TnoiGOxdJaHg3JRikDEJVrpjGyCs3PJMUoTOzeb29qt99fhMAajSEohAXZVFbDv8RUCE3S6EiZNi/F4aV9Mq86rbKOgJTPAnIBr3En6qnBR7Z7Xvu8ooVcAiB8dozFFSbgNitpjVLIFUx10LnzqwtI4TrLKP+aM5HwmIZ0B90cJOwfMOaD2tOqldRfowcaYAX0zloUxS6lTS8PSwLr2T27xT44OhvG6aNyVzNbXkhZphQ5qEPI0NIzjtb3GkiE17ApZIF3iAa422ONlz+LbGQrjFdAtvCgjDZ3McA+gddbbS1s5cg+dU7X6HM3F8bfasd4B1UJwRA18XfLHDhSRQsETfLsDHUgrosJTLAxmx41SPY8CSShVDx6q9M6POalzqU/2V924RvaODrbimfGBR64JZ8mbvnNB9kwxm2dBx+jDx51dgTs7k3+YjvYKWRVq1qJtgFFQcaH1nZagrj9SCKJ7Won5UfsZM32VS6QNVtavCpVSeaz26ajuMBnKqNIAP2fL0j/QDsRdBCrZGAH09QJ2Y1+N2I4pjb0Cr5/dbd++hf3rdNdRt/5pYjlr1x1enPTqfsZKKuSNKR+lkp6ttx7dlphxtRzqsuQqz3tImKwUXkxaMeKmSb4j/j7bGTw== jonathan.hallam@digital.cabinet-office.gov.uk',
  }
}
