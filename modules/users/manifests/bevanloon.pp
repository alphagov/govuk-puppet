# Creates the bevanloon user
class users::bevanloon {
  govuk_user { 'bevanloon':
    ensure   => absent,
    fullname => 'Bevan Loon',
    email    => 'bevan.loon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCn8bCPg57zxHgGyRiE0gouc2RkHvdbF7rsqZi32f4WnHM7SFMuOz72FX+ft6LGBAUOrKqxhxV8BZtrgSKk94jT4DUWe55cTgppPcYq1hArDceguhA6tBbg/xcRvImz7G6t6RswPwdcu4voAWat8OszQmGCMjN1UI0uWDdddFOWC+yx56AGxb8KIX0n+kZM9C4mv8KU4evHqO1P/ib2CktM92mdNYfsn2AGrJmABsOIMKjwN1JD+0i6Qi9SFdOvd0jVah0JALb3YGLqYX6yZgwIfDVTsX7vyM4/mASGKhlKqeD7tiHGY9OFIAVZTJAcTvEpKiBUr2M/EQSlpHV8Gqgaus+W0JDHAWZ8qwCeoHh8K9M3fhcoU4olgVu6+e7Vk2TQ0OUhI9+HUB3P1oYjcLGlQLxWnd3vvpztjjfLyXKkNDw+9emVikE7RBq/lHN+qRShCXvfXvFK45nIdYvVGn6TcplfqX99nDZbyPCPqmbJ/9/KuWefTlkkHi76O4W8kREmZO2C4bshPWpYI3QQbJDH+kJ88JsEdYdw7eh/EDbc33GZP9aLoM7B3fc5EvabUg5N+havzohR2k/RR1iFKu8Y2VXh3ckDkbO0WPeOqG5AUHo87R+xqRmTi7gfFGnjjRYMFePqeI70iFDC58CjKZg0E54u3autmDCTYxxo1HQr9w== bevan.loon@digital.cabinet-office.gov.uk',
  }
}
