# Creates the pmanrubia user
class users::pablomanrubia {
  govuk_user { 'pablomanrubia':
    fullname => 'Pablo Manrubia',
    email    => 'pablo.manrubia@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnNFwcQ4wDDBuGYnpkMd6JxuNLacFOkAb+MLhtFtgynsi8JuxQCnTrZP5FeLv4X0J/whK7cO+NlBw8ZFBPWRJSllSEGQK6oIq7VyQ9MCu2qkXubiQAS/miCGE+428W12+LnwIVOqmqFjV+j8TUSQ4lPYrfuoY/WE49Nk1FLN1fIuHpMwxSL5W8UYkUTJfpZkXTqkvLAbeK5yJzmjwnMcmaWVg4JEnSwPgBpCN6pePfzYSWq87RQH0beZwhZC7oTplo18iqIPVXhWp/1cp4zGAK7sL/vWOfl8qqiFZ3oLtNSEF8Uw6jM90+gn2SO3M4+RLQJMrknpJNuh/eVkveXvuwMLYFY8Jn8QGrkXeoMrC32eZ+OG79hvmve+NTs1ylgvT8j4j0O0QqEwTyXg/s73lvxMYKKDfuTkReIqQW3jsGwZHdPE8NpHu3sPbGPJ0E4Adj/YQdjq1IXEmlyhI6MRnu7ewn3UbdbXPUYxcJo7uya+KbiTfNlQ9j+ZZVd/d48+Y1FEks/46tdZ6GrxM43+CHM6Zp+/WBTIF9Ap7eN2y/fh6W1NtEvTysIPT9LSJv5iTsOpZdUA5JtLNvW/mfOLPUKdJxatcCuSBY7B9ppJswPVk9IHQF13Ug0oSiMnteGjBA4RY6t1DPpTEgZkx9h3h/6lGZw7BNXXqpp112ieC7jQ== pmanrubia@gmail.com',
  }
}
