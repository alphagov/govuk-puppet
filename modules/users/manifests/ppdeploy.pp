# Creates the pp_deploy preview user
class users::ppdeploy {
  govuk::user { 'ppdeploy':
    fullname => 'ppdeploy',
    email    => 'ppdeploy@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCroP78pg1I7rnvVufTv9MjDkDg/GdQkM/RWttLLUVoDp/PU4kFHwORbbhDwW9VK+1rQIh9pt/k8RsC1JR5xheR1oIDypH9qq4i4tV1qoEiEYIijZwMM3ZASXZMbAXldPeTozSnmU0HIoa/TJH688GyQXsptEXz+J1ucdvD7eQCy7e1whHYM8aP/8BG4HGBUUUTU6HH2s8bF8APXhwSo/C0k3+2KRnnmqRbPuqTfVLcrVcebO4iH57JLxX1WeRuvorpADcxBdBV5zMsRk1Kc8ennmveXt1Xe4MylJDaABiT+URQ2OUJdrKnT4OpXhjrh6gHpcaeS72DDQ+0awJpeeGn',
  }
}
