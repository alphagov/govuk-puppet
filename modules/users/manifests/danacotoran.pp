# Creates the user danacotoran
class users::danacotoran {
  govuk_user { 'danacotoran':
    ensure   => absent,
    fullname => 'Dana Cotoran',
    email    => 'dana.cotoran@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDd8fwfzn7pVf52wv6jsOqV4ueBfTluK0uOQaATZ5vV2godlANKfDwdKEWRCgkxqeoFBkHN4/u6GYgayzicabxS2ThDcRDlWTGxecSo+2T05Fpk+A0xYixh2iiFypBgdXQH9oKIup3eqRJfYNeYnqNSuExCfe0hlQKkGEICvA2+MVI8Dm4PYlDA9SdCc8KD7JNVrn8vzd7wHzFnQo5m4WwjTt9ecFdaERX3iI3WugcfH2RQTNTNF5QGG7BUSW5l/vu77hHD+7SzRlHplU9sO2WFs2ZwrgOAtzLnYwFvvSZ42ERoucM6O6mssueHlXMv5kiZ9X45IhvNoow0IwaQI7HEuj1Q8e7pcIvUx8UWx+vEZj0dog3gMDPoYv6plgv+oDrzyJpjjiqsqC+J4xpw+vvX6V8K0mMg3uIy/83e6jag2oGX5Ia1xr4TcY5amciMnrpa/wKRfeSlwIrfbkOlzdhQ26MON6tIRV6bhdJJ4NaoMtfWQTrhHWH5qb6Uu5N6PTlBZA0/duCK2rh6xdprARy8aQ393lFPgHorwmsNTOFlRqj4+NcGWGCyzNAusy/V2hgGnv/rrRhS3QXtjUD9/pvBGpDPW/W82DHvnJOp452tlIOF5nWKf7Gqf7/E92V2o9VizdynCYzhvuhy7AZ1s2a75zbISmchMSS3HSn0pvyGxw== dana.cotoran@digital.cabinet-office.gov.uk',
  }
}
