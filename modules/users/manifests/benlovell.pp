# Creates the benlovell user
class users::benlovell {
  govuk::user { 'benlovell':
    fullname => 'Ben Lovell',
    email    => 'ben.lovell@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQYfJ4+uozMlwkedXizLVLVmGXbr5BcmilzsHqxoVLWvXqM9Je0FdBloWdXk3iAu5xKYePPgmP/25ryAjGHEnoddiisAyFjsDmW/xRkN0NXtBmghgFYxim+S9YC28A3iq5mlXcHzYnJRTbGxbCIOCt2/oti2JJpNkDNwoQhtTlfFCwyvTIQ+thVHQp4Cf/wKElpkyq7NM9M9iLvSO0lWAfz7acbrHECIW4onP1XE4k48sRZD3gl2FuQAjBlKIyJ0Gbs8NP6ptHFlGNCX0FrUYmTcz/llBAutgDoXGYJu3KTE84dP788627k1nxoa3LbBaBZx8dbqtuU0EP77dwuiI1 benjamin.lovell@gmail.com',
  }
}
