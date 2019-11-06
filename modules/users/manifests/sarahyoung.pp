# Creates the sarahyoung user
class users::sarahyoung {
  govuk_user { 'sarahyoung':
    fullname => 'Sarah Young',
    email    => 'sarah.young@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjuDmnGyqm/IoFsPEY94aNJSkb6xJHel64OEW/ydeVdHXEZi17FrkzioV2wc5yh3JicmuLZEuhEoYvH0wEc3A5kq4x0a0tMH0UaQ1x1mp0WmyCdlQbQVgGlbvWWBdPk7MNyqTKTWrcHBe1evhOdh3koxvcDdJfvnERhHVbl9TILKlcxvRMqYUV+o60fmBcf4ubdFAGmmcv5CQWW9lNQ1o6Wt+N0si0g8pnZENZGHvvY/sbdeN757IjTjOVGmqhrKu010HNBD2u6Njrx4V0ueinyJaCD98NOfXtCBFgZnyFRalnMFl5C5BcYB+ay/QSdqJVIWucscBJn3obdDzZTN2GRvtw74Q9jH3aoTbUd1gS7LvPXiP6dvWipegQ/b3x31jbb5Upoebm8jLLppRVsySSg0iSBG90DIMgHINvPIjm59nad9UNqy4CTZeJMMYxQsfpQjFMBg44aLWOYVRaEeZNmCejWGUeeaeUWR61+NLSq9MHnl+ln1/cF4N4XDZwUoyfmXlXbkBvHe2T+Q1zUF8xvmebW/KHXIbdunA9VCOP5ebTncASDGvLn2ngxD88B6goA+2dZJM0SC+a8tt1r9X11+Crvzk0dY0tWWdsL4WwsPjFwB/V3bupAsILZUk+g2UY5FRvV8rc+4kSaJERsvZYcA1/NPazHMe8dx2oIHFdlw== sarah.young@digital.cabinet-office.gov.uk',
  }
}
