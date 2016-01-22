# Creates the alexmuller user
class users::alexmuller {
  govuk_user { 'alexmuller':
    fullname => 'Alex Muller',
    email    => 'alex.muller@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdvvlsypohk8GO/OVu6oTpJMBf+uxhpdk6yjd7cELgD2wrLQKggMCLRzi+04WcLoU8YE/SuEd8fwiwvhi+wauRKCkCnkuHQzexA30cLqWpkjbzZzFiEp76cBevbR/btFKWAc8suxhxGQp4i90QjsAdIuEY230cpUURbGW1JRdhfF9n6nQ5HVWyZ6Q/0PqzJvB8k2GNcPGYqmPW7V3aW0FteEvf3a27K30dUkOomUJGtXiJxkAe81aovxGcLwhBFiKrof35+qGylTlgh/XMcdjxdBstUbEBxi0RzNycFGJnwacrolLnn0Zsm5dLfi0nLCXgK7yxGFI8xoJOdb4GBKvMiDtM5qHnE3grIXjjpmYZfEvY/pbXA7PBjhIs2GfS7YAPDDOWV+fME1+UQssd9dz1kzlej6+bg/9z/hHdWylN+G3cAC4pRNHhvZUUvOTVjCM18KZdRLzIO8BPADxUDLqcUznR/x8jeAMZs5L0TvBQcnZsrBnm2gplPmzhh0OYGdlgzDzDPmR2LBKyiCQCxANEW7Z4alJRjRHoq2dx9BawUWBsHFJ9JexDLE2XvkRA1vqhQSQTsWn4eM/PnUUiSxTTh2fVme9SC9rwL0NN1VB8n4CCLxOU9EMLRTvVawR2pNlDeiowDiVT1Fpe1NCUAlVkGkJP9h5/GupYt2ufXQn2ZQ== alexmuller@gds0386.local',
  }
}
