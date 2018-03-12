# Creates the adrianclay user
class users::adrianclay {
  govuk_user { 'adrianclay':
    ensure   => 'absent',
    fullname => 'Adrian Clay',
    email    => 'adrian.clay@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDuDmbHhlGrHFhzAtoIgVtCNTOBhtN6T4+HDTV+kSW0hsam6K2Atja4nb+qF4kamAzyMqd1hHsaQ/GLrnVLMagSwfDzmUt0DhoYV8FHGY/EBf87py7Mm/z4UadDhCyyAKQ5x7h9i8WkBhu2D+m+Z+YSsJnVeRdhConjt9S4f9mwKrsvSpOOjCrLsPvgj9NQaPp5qF656JKnvZt22aWvTsj59+JVl4wphrBaUff4MrrxM5gT19Kh1k/ZC9K8U2ILDQDsm0xVUmi21BsTD8E4yYLj6tV+mtykG4AY0heTUFS2QG/tXebxXs3G3uGlxBZ810+shaMbyrulhBd3dD8sST+iNhQzQu4JCez5Zo2pk1FSg5BpVJvxZtDHG7O1KfPVDnLSNjxwBLpsuHzm00Y2fGdHnoetoJPDTUAr9WtOpPfP3oxo+KikauddrK5cghGIBVUGkgYq3W/x0tmsh+aypi3epdufU+PleFpGkPGd3VBRRFYoSDXvhk58tcTIIRmKeFivwJYR958mQauAG7HZBhhyaQn4S5vvCQHEswiameAzeX7cDN0cyjh7KWKBmL0+6Ic/7xZbhxDqFOnCCkK20h3Dq/Ta62L5i6370EeFSGYE+lb0OaaO9FLdOQOLHalfg5DueSPKBmvivG+p4kJX6avLzcdvKbjcABsyAnHVeHaUqQ== adrian.clay@digital.cabinet-office.gov.uk',
  }
}
