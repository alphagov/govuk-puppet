# Creates the davidpye user
class users::davidpye {
  govuk_user { 'davidpye':
    fullname => 'David Pye',
    email    => 'david.pye@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5wO2B/2a6VEm/Ccs+vuv8F5zV3JcuKDSwPzruA1BhzQdsaHKWzDEzwEcmaZZ2dnbDQ1LDCro/Y974Pq4qzgQhKTSn5RXCgX1za88MKYR53W8opfLu3sTzO0cuJZ/3EAjYpxGHtpFvmtFst32BuAP3R7Gj0ypBan5ia2GCsdWbJ8c78oyzHnj3a8Kq5UaLNReByePGRK7PiZh71V9C2bDf0i8RwF/wHwgrjFUaTd2kV8wAXKLgIvz4KycSc1/ep/IhFpdemcrPXnHR6IPnMjUZzFfsIUF0CNbGRqbWvvNZVi5WEIwg9HQOBSY7D9tWuo1ma1RudQLd6ZvB8c9h9iKnWdxBJpERRL+2OOVXFeUsOd1VjLeil2KvP1DlhLjHEvYjXGtUjLVBLX58rpP6LE0Hv/pRmnYIoEufYfP09nPpfFCMN/kRSEMjx8LuGiIGSJKz0vrS3DqojsytRKQ9gwdTjmgv8XMjCjxuXCQjFMP9LKUoaPiKTSlfG3mGoXQdMIxc/FyyuxLDRxdIA0EYgUcYEDZdelo+qSM4tEo8RuEh7CslS/TrGaGckYbAvOrlI+HFRtI+93TBvaV91LSCkjprez4Tl9DG8Aq+8+gFp67GqO9ytTbmgbtwpSnkyIqNxW9eR4HEU3+egl300rYcC4P6GjhTcZ5s0LgL/OsXVkMAuQ== david.pye@digital.cabinet-office.gov.uk' ,
    ],
  }
}
