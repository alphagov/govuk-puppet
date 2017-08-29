# Creates the timblair user
class users::timblair {
  govuk_user { 'timblair':
    fullname => 'Tim Blair',
    email    => 'tim.blair@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDr06u0UM5mYAAGoPYS0CciLjGKlk48LxK7NQIIq6KmoaNG8OmbZA4NhEWQZS5n+6ffSl6s7g2t5QO+Js+/Lib/lRhAbtI0U1x2FkwLfJdBTBLTAAUHMm1xRtuGs/NImzGwWQO6zDjID8H+6dWhZZTAMOCgYsyGLm1k/QRWFVgkgASrJZN4ybvqsZlPlGT5oi0JuV+b3120AtUW1DkzXiYr3KExxP2P1nsJEp563EomcTvpK/eo/ChRbjBYGZX/JykhtArKj8oTKgSSEwz9UgBqlKDmnC2hSyejhuQmZJ5JiKa9Bj9mx4XmpKELCY5wNg2Cct8dRF98DEQ6Xo6kMg9KM2HOoqFJyAoBtxVumRLZW0nRA3YiAqE0qJ4daxaSg4T3ktkuEA0AtUYnH+SNBseDuZRDTNaBhhzf06rp1WGCm11R4jpklqs93uOC1QedpidtHBgj+3QASSo6aGb3xnF6xLw+IuaMuUdG+T3eJtF4qqLH4dK8n75errSPpe2UM2sbxyBjDJo6lFDBZ8JUzBaJToHuXqKUxT1RUtsXIL7Skd15Zb2S3rpKRMjm5HVJBNPUK5F/9GRI7lvREZqPy0miJ6mCqm/ICvttOH126BgWaetANg0VCIgG+JjV6ZbZz5zOA9942gi7n3Tta1lBdb7C7zldX5DdH53c/fYYyxRj+Q== tim.blair@digital.cabinet-office.gov.uk',
  }
}
