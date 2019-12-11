# Creates the thomasleese user
class users::thomasleese {
  govuk_user { 'thomasleese':
    fullname => 'Thomas Leese',
    email    => 'thomas.leese@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCduYf9XCjMh13onu0EFWIaii+lZKCkIiMSowOJKmYZahMdrzFLU/qAg5gCLXhKZn15WVSq7z5j/6Q/Oi3zysz6PQuOpZct8h43OQZFi+D4i4dPYlNiKhQu9vq0vFzWp+KN90bbGzFQdJgHJEoqpvydca98IXuiK/vff6s+mcc7yS0Z+TGxKeZwKRzOJy3+t+Cr8ewQSve0HxEQA5Nr/d7I5HlK+dqU1JlWVwrJppRC/90UMEvQfR1WU0ImIr+05sysuq6A5ZK2TpUcI7zrIloCyjYZalOmRwOKl4s9qAoYUJWLYGnnV32fJEANkznrxTaM+reH3koT+DYuJ9BCantOdh5O9UdHC3QjljklNJcvFWEbMiDpOe+yV3dVsWwBs/KlEtsQkSLeB9acyujc2wUFkG39pL46z6v1MkuzW147a3Vp5Outn8ssnqcEAS4+m/gcsOXsogUvbSskSIV2M/5+WGW+6ekgP23JMmGNwblGHRnko6et3/f5P01w2v4kuMVTQgwSDysOfdNd+x5a85G0h54OMjzE+z7ISIFkZOkcPb/sdNFdGyS9bGTOiCRqnH8mQ117JSClb5JtIkyAa4eTfhTommUjwiVHI8lRvGKdq3idwvSt6jnTNTk70p9SXtyQoOJ5jBPFbkE36ahCXhQFX1fZRHcWbsj5gumUd2myRQ== cardno:000610162334',
  }
}
