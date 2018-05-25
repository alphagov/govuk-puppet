# Creates the michaelabenyohai user
class users::michaelabenyohai {
  govuk_user { 'michaelabenyohai':
    fullname => 'Michaela Benyohai',
    email    => 'michaela.benyohai@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBWdzo8bSa/jm95AtgkRmIOMOxXt6sBtA/s6tkQ4R5I+ZM+jK0Gpf+AuIwzlNMIZjNXnH9FeX0Grm+gGK+wRUSbjRMkzoAl3fJhwDII5XY375aiz8VcuLEwW0n4/tGu1qKB3UlB67etxdHBksrgNFEJPA3/EzOizuugVFC396dUIzWEBVFJ6fY/LIlaBnQWkO5lT7+t+PnoBG5dPNslDEYgfp/+p9MxgAX/kzSpEzc1qrtcTwzZHMaO7F5Qix2+QeZ4GTDY3kuDnYbHKRXFHN9lOYoUxHLjXiRNiyqxx5Z+d7QQE76sxidt7d5//amJY6F3KQzXqpJqfbXfJ0ZPFE33BS5SAZx+o/6oE35yays8DjGT98piOGKko0OtCZYM2wiv+d51KMKIU+BFKv9ZxDlMLr/hQulTtjR3BaAWDfLISzaB1N5qqinYXbmEV31z/ymcYGK2LHpV4nIs60ph2CFLzB+nr4eUmf7AbK9IPmYnCnj6JRFwvF7JYsDcNurDcfzkt+dponq2jJnH2SeEjghS1BW+cif8xJtXCdz2i1P6i/ISt19Enwck6iHJ5FjT6zamupp2Lpp+1sFBKoKX60ILGeUQMAzDjCV1mCUhzh8mu9cmf7LGahht+PCX7zBB4NTt5fOYo7uSW1AFB0sPaZwMlFmeO9G7e/5Feq8sXqBvQ== michaelabenyohai',
  }
}
