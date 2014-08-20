# Creates the jennyduckett user
class users::jennyduckett {
  govuk::user { 'jennyduckett':
    fullname => 'Jenny Duckett',
    email    => 'jenny.duckett@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLK1FCyi1Sqiypd9lyNiuJLSuWws4WEYmg66QaZySZge2gHBfIdeTZsvaep9iklWL7OY8FzwxRGLPIwtLC0VwRuI75Cfvay4i86o5RzEKgEK8Fwy79EV1WZ5n1/AduPuWoS8CszJaLiNathTLicbfED6PmWecIjQVcr//+Q4CdjldvtSKSWasQstCq5KZnRzu2lpriHhIBS0wCFfOBs5tETUQ7NhJdFPH0AOLLrhM1qLA2P8uRn5dL9mVF7JseNoJI+d5xuODMQkCjnffqtktMi0xefRz/rohTe/JyQMcPOwzQi6GNeZobQS3lJBAksJFvfWtvGsYldmRzKBAKGF4szWJjY23H9RRm68157lxxcR0OZ82sabrC/4YX91YQmg0KzZRU5JtKTLRWNTWU1z4fXfjvJ0FtHWf9SaJ6/OAO3c3vLB46zNMcgaz/fz5spNr+59QwnHQU51K7Ucd7UAtXconreOFFwxBSPk6l7p7TeLVwvaEz1LJNUDMrPHmvAyaQJcce8H+FnhhjLsD1oi1Kocc2gQQPOCOIsd8tSkzXKLErRYCb1WZNWWDBlyzyT2pll2x60eOm965Tvkr97HYtTybhAfdhpxRpJxd5CijIr/7icRjiP9fdfGfGkdqI8oGWFHtY3kyOz3LvsbiGSsKuw0aAELm/XX7Z/7at6a+DNw== jenny.duckett@digital.cabinet-office.gov.uk
',
  }
}
