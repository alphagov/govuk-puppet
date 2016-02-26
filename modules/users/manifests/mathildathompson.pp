# Creates the mattbostock user
class users::mathildathompson {
  govuk_user { 'mathildathompson':
    fullname => 'Mathilda Thompson',
    email    => 'mathilda.thompson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpfq8YqOdXwI58NxsbFlIIvb3xIx4Vk5V+u2mQbrsy4kqyE6M2u79rlfv4mAEldjc+ALIeuNFZ4IQ1P3dZIUaTbJ3gJIoBnVE/0kfPbcMsROfXoVmfCvvTUpy5rrRAIm+jlBWTRY/T+WIXOgk5irx+xUn/sK5wo6zbPJ7+LD3/J89TwOmF2nOVg0e7KVGhc7Km9QiNje+rhrgy4RGydKNHhSUHJ7sTQxKvd6V+F9B9PhioLnqkhCP631sAtICYMCljKR3W8xazNmkuHnrW6/DGU4Ky7wca5pTssoULyH467Tb1XJQFcYWM1mf6OehnkCncUvx/+WJ2gNIKeRrOhj7ziROelWkdGeJRAt9QdE8pxFYxs9jKQl5rIL5mIn0JXPNLHc0qxFT9yGeKEnagoPeTG813CVCLsKvLR0WH20FSUumdaZ0Ciq1qOrdARUJqYyfm4eFXbomaCykuNAsT7Yzq9OsoAxlPABYcKqaXS4nnrmeKhF8DkBK7aDSg8fGxLk1aM5IMg/a2OWw+H06/VCgD9TmS8A40raTmCs7ALCKjqp6OuYHe1qBW8+sGowu/Sxa3d/vova69ota14t+iYN4C5QgR5qzV9of/H56FJ4nFjFC108PTy8LPHqhbpXRc7zt5AjgquPN02Be4FHKm7ekUXP/xTfngsmmKJqNUNw56Zw== mthomps@thoughtworks.com',
  }
}
