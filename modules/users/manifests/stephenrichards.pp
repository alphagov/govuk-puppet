# Creates the stephenrichards user
class users::stephenrichards {
  govuk::user { 'stephenrichards':
    fullname => 'Stephen Richards',
    email    => 'stephen.richards@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYg98uS+StQdiuYbWt/QGGXZxFAtrUpm8CyAUXryIyHmDSxkWyfNsuD7NpPUb0GNrbvZ2t2D8d5fsc4IdcthC7j/HQtAWX5dL6JAWt4ILOs2YQfgQYTULHa49sTd1U4nk707AkzdVZ4K4gY+7s4L3gpUQTj8x63+4fSZ+kmWcZABgy/3A9jOhO+BPdqHKdMkjN6lgjDd9l888D5yVgrVxl0tT/ZaXm8I3eg7unl3vuqwwim5jMYk1pw2VnPkumk2GyY1mnSmcko5y+DkoLGtYvZwE/89IoGBDqKsXNthFBIHzCFLfNLM9kVfyOSE4ydEM7TeS6LZz/miQHjof18sSBot2JE+ko+FGfAEzHVOCxrza4u4toxJBI2X9ZcahOirMvu2ZxIFtvk60Pm5SspZeNkCzwJWC7icCqglt/nUqX0AP6aJf/MwJfeo9OmyUkRrbrHmk0Qm3VLIjTMtlNrwgD65ZCnL6mzWhgIpA1gyhaJJjw7RfVcpWtSuwgIMeIf++U6N3pGa4OYcsbbCcyyM/EHyMb51xl23g6foTwtH9XyKZlMZ+9geGYaHrmQcIbWOSOZUOgQTTOHTlIolKCkHq1XC5Wy6cgPjZG7nwlxfGjAhNzHvWviL2s/ElOLGFdxkPiVbsDFyXdSG4PsdCWZKbHzxFOJ+S9/Z1G/LdSivYmXQ== stephen@stephepnrichards.eu.home.laptop',
  }
}
