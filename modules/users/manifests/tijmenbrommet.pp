# Creates the tijmenbrommet user
class users::tijmenbrommet {
  govuk::user { 'tijmenbrommet':
    fullname => 'Tijmen Brommet',
    email    => 'tijmen.brommet@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhD7H4a/kxBHQ3axRVGTSA8eBV7w3siduSHpQeLK2jbduQCr7O4uNgcy5z1yIfXy5BQ5xZDtHkF6BVIQCSt/cW9287kvv1UzjDhPS5fbL89E2oOcf9dIvUptALHN9iBf78eoEvGyEvCyoHdB+91FVAafFif6taSr1UmDnvEmDzGg1hK49VMy0D8islMBPT6mSkXVPnPChVwAxWFyK6eoLKJ1Ldu1dQI4A/IXrOUB2lTE8Vd7Kk07FIhx12db0qUqupd8rbD/gj2sHe3Q6EZWWZQK/Jxzn+GYbd1amv0q9zlsdt+o5rWRVZG86rUbgETfTOnavVPlMLhylhnhGSZQEl tijmen@gmail.com',
  }
}
