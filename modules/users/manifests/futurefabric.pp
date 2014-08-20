# Creates the futurefabric user
class users::futurefabric {
  govuk::user { 'futurefabric':
    fullname => 'Guy Moorhouse',
    email    => 'gmoorhouse@gmail.com',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyQ2gpI87R74Zn65+ID/60Ow0+tdXj6gk3Npp818OjL2OaWxkjo+oAJZdwh/IomwrtGL0urmijpXpNfgbdC/2yV73kPxpLkJjxQ03ThROhFA4miBYXKhaReR8GTYcW54IOeReDXFe3WiLJDQJ040W8Umpw4g1Dk/md9mqsyy4vUHl4JDTzoYxhSHmeoikduphTBSYmXhNuoag2CxlNdL7E44POY92j1ICc/6CSiJk6xK1eOswaj67FZDhqhtrBCxo8XtqEMqzqzKPGnN/0Wc+AnQhcS3Jxm4TQpM3281GR6mOmV4W6jq2Mpui+ALFsYlF/XdlSvOCpqqkix2V7DUYv',
  }
}
