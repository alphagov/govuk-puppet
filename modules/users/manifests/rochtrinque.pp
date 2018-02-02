# Creates the rochtrinque user
class users::rochtrinque {
  govuk_user { 'rochtrinque':
    fullname => 'Roch Trinque',
    email    => 'roch.trinque@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDa8f14jqnSliL8P5+3zeIobjjf1Pt66jiZ4PP3lDnywYlGDiI8Ix9XNi9veG/bM8o9a2NPETlzKfaUI3hgFGKobUcTGOGxMRtf9dUUoXs129ZyDtItooNaj6q1AHXZaySDWhWrIAd4ZdyM0KSfSxQcyeVav/ox6Veyu0wqNucufEhJl0/t1D3szItyqxEbaFIMkowpDsjZ7GVlp7oTLhL0X5z7172DfFkLtC8VnWaFi9ZcueTq4N8P+m9W+qtx6Sfx47tpOJjggEM9grFI0LYiu95RWUW8tDV8Fx/DDWOWBUBng2KeFCnFlNYmvxSkm6+W6yEg14aRumH4oIamAl919trJ/Giq36fwV/kPUzs0qagvA0ZYae8lnCZgtf758go1FenOWluOlypmDme4j8LqAXL3tLWNakigQ9ftGK8+xTs+3IdtQ3VKfl9gdf3ffT7AZ4l7Gxvx1HcfHDpcyMSL6Z+JWGR3GBvgZEJ1dsoQmqsmeP5IqCQERh4kPeVe2ekW13ueeNVbaqoPlaqbh5pG2YX+MaxLW7bwdcpFXKau+KEJx1Zmg1vk3qH2jxxDAvB4DV+jhyf9tHq/wfn/4LWaqes1hxJUJH30DvIWm8B650cZpIVGWiSm/LwSe3/gDYT+VLb7MtmTNcO2DqCdfLdQWWbaDq2gaMv4oxvx5UHGBw== rochtrinque@gds8064.local',
    ],
  }
}
