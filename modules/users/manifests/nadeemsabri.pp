# Creates the user nadeemsabri for Nadeem Sabri
class users::nadeemsabri {
  govuk_user { 'nadeemsabri':
    fullname => 'Nadeem Sabri',
    email    => 'nadeem.sabri@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7bdqN/8obqFB9PCk5kZEkxLP92p1LX9IkiDv7DqtJPB2ijPxasSBJHmNwN3QvFIZnOaQ1vmSRGn/z9ITiIJnqU+K8mRCiUcRPzoO+7PLXVml2llsCe9aQEDCm8l4O4TF86Hy/3+BTNJ5CoF+MpCgSCxuDxxEKQNek9O5jORGVsdbuXwyk46NzKJW29qDgEXC/JvUTMoqwxHHOGS9T91X+ZEMMNspAWsUT9msb8KQ3vQIphgD8UHAhW3wjPxG+LQ3+gyaUw3F5Ltil5Nysv6EZZCFwm/KUEYwkcCbJJGHh1qUSTf2D78YFNzV8M5zuVeSlPeW0osfJe8hyG94rx3gVgiyrplSCbS4LExuspRUEsd7SdLc4FCTCDp1hsR+6dosHHXm0ho+Djw10dfeGYlQtEmAHeMA15VQKhTeIqhE8A+zCdPyOv63fm3Rr/jpjrzmrrDb+gOXsARXvmkm67bkaeP7ffdOpxyOBau/7uAhjCbvdRd/mdg9oUA5divR7x5vZxM9LPFNr2g3p4ZryJ4AijCYv5/zhFAZJtO7qPZdABcec68jz0D4zBz0O5lTgvrCxTjuMDyJmHTKyRVUK7/ZeE4edZ/Is0X63AaTGrX6V/NA9n6U0jitjK917vsIPTXl8/d1F1NX8UZ/NMn/tyBE8hUwWW8ODFr9E/D2XqQehjQ== nadeem.sabri@digital.cabinet-office.gov.uk',
    ],
  }
}
