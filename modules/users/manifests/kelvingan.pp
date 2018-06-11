# Create the kelvingan user
class users::kelvingan {
  govuk_user { 'kelvingan':
    fullname => 'Kelvin Gan',
    email    => 'kelvin.gan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCk5tajqNMlAHl2py68I9lJ4YQ7JLNpkDxduguECiHeh1qp8ax7Bx5rJ0XOZqg9JpRyaXdAhl7yQes+JTAnwDgDA1EKjv9vPdLL3Oy9BiWNGEt72oT/vq6QBoz2Pe35fCS8bvvZKnkJKu/YFO8eg8JcifuJ0tzXpMlBwy1hgbmkGmfKxeZrRLxjhZYA49/3d0GqeC91uOw+Gu+ifuCiwL6YlAIYoO1NM8zCk1BPAPx7FPd7hmNV0OsmbGwME0T+9O9RonsPJkVhIDfHijrfZGmG8vCc3qEGVw6oW9W+IgZif1v+KPCYvGxcwK7av4TXYYZKER5rocFj37ZKIC/3Fg4yY4qyqtH8fU1K2EAFb/WjqnVYgVt40rfKT9maZLxQzFDK6AoyC5yeBeJk5Wl5m3O98hW5MNmFmQcQ4JO39EGwbQulg+bfcnojlqCdrhIT0c+Qrn6lyBNHIp3GUC+moHdfDD7FwsF6m3cEgFcMwvmItZ9FaCxvrnr1ivEeEqmjKc6krsi0mdi+T8yVYxbL/01QmzlaqWKRBodLPd1NcSVrZlFnEjQ4WsojmdJIgUzCkP9I6P337oACRKwiedA9lhHorzV3sP09EAmYKp26idB8tmmH0T5d64NZIbhglQXhu216QOlhkiJsl2EOLi/kAPG9jFenYwBbcn+aBjCfqMPFw== kelvin.gan@digital.cabinet-office.gov.uk
',
  }
}
