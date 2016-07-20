# Creates the robinwhittleton user
class users::robinwhittleton {
  govuk_user { 'robinwhittleton':
    fullname => 'Robin Whittleton',
    email    => 'robin.whittleton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeTgYlG/u9oFih9d1STR+wKGpnW4LxsGqohyDH6jrFPIcAUWztWEvGp+BmJ2eglj0rOgEbBzo87m4+OvSJATm+ZrEGp5c+XPYyL0Cw705G2YDbCnUmYgehWsL2yo4NyVQFlGl2O1iwe0DoGUfYLhzP//DVyM5HPk+GbLzLw2nGbDo2m8Bma0ctV0BPrDfAbeD8uSXhcIhf0hVDvbwuWx1tvGNSgHquzzXh99fcrAuzaOMIRKsUSyglX0nKrEJYFR9h8dKTnvUK1Vqm8hdIEt151xhFup995PQ/noVCA/rAq6vIQkkZw4OXY6J53ZOZUpWl57+t+01N2/BjajVXv2kps6522BhUwriuP/0pywbngE8K6Wk9bJ4sAq0m0mDIMVV/rlFop1tJSlXxq8j1IqQwy5XeFcOemKE4NINF5gt6Bw6gwG6ojy7OIFyn8XS6lSPOoU15GKJzbknJdFLTTm51hd3HhDWjC3z4w+KL1GCo5pm9SGa/3Tih2u5XSHtP/6dcsilSautn8UTyTYcW7/sm73qMCTojz1Z+O/V0WPNbQlHrGemUfvZZ7xdxrSjFVy9FgIFYh/7hbpzuK4Eg9b+XzArla0Nzz6AJR0pYG6AlxVdtFo1exNxSgcPGz783RdkIF+cX8hSGs2s3nZDNa2vRwNnz1XY8iHEExmEbq920Qw== robin.whittleton@digital.cabinetoffice.gov.uk',
  }
}
