# Creates the laurentcurau user
class users::laurentcurau {
  govuk_user { 'laurentcurau':
    fullname => 'Laurent Curau',
    email    => 'laurent.curau@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqNDZR3oiUh0uTEpXSaBkdJBSNDZzi+xNj+7gJwW/ZPxKXmC7YsNxpMG/5vjdIWPrOB6yOEBCKbHMTRnMbSzPWfBgUoJpiU+J4MS6p9KDVZueocl6l1FOZFn6YPlyAP951X9FLK5EHVZEqUXaEkKz6nzYYHcZ1feGmtsYqOx/xyrbtNfmLO9g2UH163fLfi1NCnLZP3qZ5nG4ayrTb9R7U5vaBeZSA+yjDh10OV/leMrf+cNbS3KloQ97atYM/TOOM8/OTNvOOSvf0WysgEDlRQcpUSju9ENPG1qOECM6DJm76EnGiUYVY+7RkT4dexzy6973Y/PrlT3g723r78CZMicCJkUFy1VKvTSkQDiJlo4wQfzH4kZWwt/xLsJr1S97IJ5diLuF43eYjkX+LTT1NDW9691xNnMukH/gs8D6k6RJoLGRNrgemJybqOmV/o6qV/QJYUia79zA8KMPJiS8p1K3qTFmTSSHDGBqgkDMVPvLZZzAVzuYny+1LCyY+fD2OjrJvZv67mxhoYEFllJOyRKtcPTnYk4cdUtP3dgqOmzfnsVTa3Fm5fYJ6W7UGtOyNCJTwDOpgDdo021lXgwEgHEKsDe1OZ9rFiZknleqZ3GgDfnjM+jyCc7eck+ZKEHGeR9zPdZFe0MXjbXY4tckIL33jSR77Te/X6vgzFQZexw== laurent.curau@digital.cabinet-office.gov.uk',
  }
}
