# Creates the grahamlewis user
class users::grahamlewis {
  govuk_user { 'grahamlewis':
    fullname => 'Graham Lewis',
    email    => 'graham.lewis@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9qW/jNIyP2kLykSmBmvkaOL0PgbCUGrdB4uH+Ihis9k41MyLEV6czTyst7AFjD5z0l3QQzrt5FEo/JajVspbnVRDA+w4ZcrEvqCCpzaSvdU/GkGKLaL3+jmjqcUSaWwGqzNEcLSyTUuzUPDIZIuTJAV8YU8pKWXdLZ4z5xHw7sWvkkHJdYwnRG9Uw+pE86ffQvqo+Yw8M8nNS6CfUMie0//5hZuIos6ftW2iUrLUT8HqDvMHXtHdItxlw6yvqsulhIvx0t1HQ4+dN1iVZW2GDNbdeUBSnYGu4hGcZicHSIw4qdk1MY0QKTJXO58C6NCTX78BhaZm35yTcChy30R7/hbnh4ygUNvuicT1R/9XI6nyHqqKLhoCqr0XJV/shXAp5RdxXImRJ+DXstBJA24zFURkpszeucl6xQi1kiUJeX+ZrBZ49wlKN+RUsTY22ZGtHT+Piw5uZfQeWLcGZHP6YPgSyRWt3u+YTdGV+S8mcSb+BG6Wf0K6MDaVxVSz8lqylKy6LIAGlzap/V+bhW0b2pTqeG7V9EBo1ohp/gQerN9Tm0nOhsGskKcz3x7zrdCCNJSId7HKK90hzM6ZChkE50BJXs1VmDly9lgxPphWKbKBLLGaMYh3waVe9SnNJ9hy/seUYDmaRTlIAx7Sm/q7HG+9WU+rR1sXuwqvxvuUiwQ==  graham.lewis@digital.cabinet-office.gov.uk',
  }
}
