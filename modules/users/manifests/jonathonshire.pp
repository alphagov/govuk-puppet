# Creates the Jonathon Shire user
class users::jonathonshire {
  govuk_user { 'jonathonshire':
    fullname => 'Jonathon Shire',
    email    => 'jonathon.shire@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO5nWhvYCSPPwY+s1Gag4TbIq95tPjfklhM6mYlvb4CnZA6hjxpSxQ/Ow4pB8FU1CBuq1E17CoyOLt3a4D9+fp0WgIp11+9SiRXwUkVA03HW9fkzJ7EN0ZfEPUPoK2TT9MPcHSoidEOL+7NUWEjOiT99hW4yyT9ELQq9DMXn1tbdkJbkLjtmx/vLTkwa3jAh9YvVkNdlAk7jvBqsMwMmsV2Tzoqwa8arh0fyvy0RdOPfmJ0lr7u4FqP+suiqFl4IYWLbeEMfnkX+LPudwe43cXKRdfpLTLjW6kE4RbzdM6k63/c9ugmPgVQE9XJRFM2VlLMPhnrPNtVy4kQkKY58jXQXI20L1NhG+WdelpjVRfrD2xpK515V7Tgg7jjL1/DnDVSDoYNZutSlZPqAsG4pucY9kcw4BRI05DYJA0YgtTzI7MYZcoLbYG72SjXJXtlD6wKGOIA0rv/zw0e8qwMsMHYW5RbjWIG7pUABWtWbew5tcwiUr8DN6hUgqTl3dwVVWON+E/FXEpkpMzip3pTlHUdePyn/gyAAYtddfcIeryEnMa/1ksooyijaLYBokXAAUYc+wlim4EofHWTz3sp5vWXvdnZb5hIPFHJWVpCmGSBPshocJ89dWdQTPE48ztFG+rYnTSGlbhQ3kCb/FPAZKHcyQwKuFV3LMGURlPAu6dAQ== jonathon.shire@digital.cabinet-office.gov.uk',
  }
}
