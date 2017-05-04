# Creates the leenagupte user
class users::leenagupte {
  govuk_user { 'leenagupte':
    fullname => 'Leena Gupte',
    email    => 'leena.gupte@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5Zh2cj90JPIE7zYJFmhAGZPkjl2iMwE1IcCEqtvturDYV1RclPprMqwLDs50aw6DhdcLisS4kjdC5CeDHRPMBwMkqnYF+tFYwQmNCgDfDpPd1925wS1qkpun3nXoii89Cn3GoD7okQuGRPgU1MQU/PI6cfIhdDVPLc1vh71VcBWWIKLHIWM5bvg9Jjeue2MqZdhZhGML0WcKzy7lkT6cJmsy7Un2Kxd6ScMH9tC+st79Jtd2h4+GylggqMBavfLE6UQM4JsAbgYYtP//rUe/E4s/3U3dtKiqRc9cfmHlEJ4K8SnELWfmSAAokYf4o1kAnD3B+Tmvl9LoVvVQFgvTxMxggaYzDVuZ5JBDgI3wXvSZ4DjD7D5XJslXsvm55hqghb9a2Pmm1B4njZeEAXGhu6peVHmjK+Tu27VvWMUeyYLsETBe3JdJ2YGIzS1AOiWECyRa2CoSvglDV0R6nCFUXn9kIuJfMphWcK4kPlA5zaeADCXHl/FmweHZNWd4rVBbQP4jfyL1PJ26AQmJ2y+bQx4AufyLAOi2/LdcrSL99edfZ+7S35ngxP+nyMYB7RIJMC7mMJzLtNiFa2EEz9tAD0LYaO0evREnjceBWaFWS0LvofeExPTEkhARwFs0CMU5XaeWfKIfOd8sfjvhPDzi2s1jjFEfDuHLaxjxC3VCkUw== leena.gupte@digital.cabinet-office.gov.uk',
  }
}
