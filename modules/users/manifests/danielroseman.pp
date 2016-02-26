# Creates the danielroseman user
class users::danielroseman {
  govuk_user { 'danielroseman':
    fullname => 'Daniel Roseman',
    email    => 'daniel.roseman@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcz+lw8fLHK2IHyIOs4w29QO0zT6I98l0m5JrapSsK9ZUASS2svj7EvinMdJJ2NQQ4fqhYMD67xB2gzhug/SEpYpIicg3aUDdQEJyQulWLigH9rRFYjFv5d6jkFkRUHc4XRd31PFc6tjTgpstzPaL1uO20XlDIaU1U2+LyUplENVkVtTuNqyVPfg8qjtzHGWswr16E8ouKtfzAuTAmkuVS19cjXiflSuXD5v8vXsVzpNbyoXDjoeu443ZY8MOavZMD/7ClrZd43m/Yi154I42xJ68uM+3R4uuU6OQgcOnNhwRnyJ21jFk7ohnipVmTxB5oUjXuh0gPQSfOkCQPvddwsd/0dmfLEKidAIrwcUllI0qngSjkei0M693Wn9zJmdYoyOTpksCpEsmSpeF5ALYOXedlZfa6WuJu7SxozfuaQScJONu5TZbIS5mM/1zRVwB15cdZ+qgH1WCG9wjFWTH3CerqfnMxqpB80nxHcKD6r/FJ7tRVpHY9CaW9iAjZ97d7Hh6MTb8Jksg1F0os0c/hSOChFX/hJpmeGnQIEdu4hE7U/zt7gVxalx6446BOPdDePDcPae8ngQAutRDNI6/MtL0QAcxDUEnW2KD9QVatvwEh3kdta+EJBUOiWAjEBlpMa34509mBI1H8JKa3wAxpQ0u9tzIzsXzoxsYiUPjXkQ== daniel.roseman@digital.cabinet-office.gov.uk',
  }
}
