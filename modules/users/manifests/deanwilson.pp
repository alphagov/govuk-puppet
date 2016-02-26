# Creates the deanwilson user
class users::deanwilson {
  govuk_user { 'deanwilson':
    fullname => 'Dean Wilson',
    email    => 'dean.wilson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAmm4kdSdiwYnIhn9wcuNGmTQllNNcaKALRT8z/3Q0Z+vSkqnhIA6gHWFZn7ZZ0u8Zfv5rig+lyJNPZ6e+1uwxCtLABNe8G1NPUdgqhirblBDy0uhLaeiCcwOP/oiZ/M94+LxM2aPLoA9rwR47rviXUwiJ3rjQV4IZzGDuB/p1d7ttaBra39HMkqz5K1Y+I7T9mhCuoU4Rd88NHVx4NmseUQTStdulH6sy+shARMUg2M4PoXEKcWasJUd2s7CuuWa3ZHjL7EQePM1eqgUFPQloac98f3RUVAfVb9AbPhA4t/zewOZS1sYf1kxO6lrGw1P7qbXTmHUR5eTGeW/hKkZSbz5VZeN6ZtihQ3mogzmP+bsDaiuAfF2LQWijwQI7M7xjk7NBjvFfCkmnw1MymSC26vnIrb+ITfPefgi2M+uaL6HXsQvgdEL6VT1pTewD8494UJtPARf472npBWXrMjDpier711rMY5HtSwenq6KE0DHFp1bFXZ+gUZeMzvyIynB4HmyNGZpZf41Lh8uenOy49/ouO9aHMN8lcRLEz9aPQXyjAWT+FooXRQjT+BZWZ3A5t1IJB7Mfbxsah+7wE+CHOtpydL4bDR+wGIR4dm65YegeBviMN2FlCle6CnU2baDK23LTCYJalBV8K17a9ydxvHgelf0nvabTb/f93PQhjQ== deanwilson@gds0092.local',
  }
}
