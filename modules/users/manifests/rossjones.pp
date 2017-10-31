# Creates the rossjones user
class users::rossjones {
  govuk_user { 'rossjones':
    fullname => 'Ross Jones',
    email    => 'ross.jones@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5qpIiUmDknWjb4Vpu21PKOEHF3W5fU45YiYnyEK220sa2UYWU0cOdwWUGChN1j+XZdToI/5ipxxWEifDYqwGKMr0VacWk3luABFWEpHhiRloY/RYDB9PCryEGYYLW9wzcCgg+VpBbECyq80PSEAeuIJGO8HyEOF5BsYhr8GTqxPytZO0BAPPpHoIZY2ecJXZ8tzviKNVbB8dwvIBqNnzy16enbYYZtLEnBXjBurgHd+r8C47qnKZ3RFZAV0IYlklCrhUmJCLOFynmk2C1BgJwvM+Sdkh9vvb6XEtSumDTTZ5fs8hyKGKoYlJGEC2O7e28jGzzO08WaVurGUUS/3tfBHz36m0b99AZZ30UBP12+7w81jtDEJ6K+gpjqpKwLvT0ae/ydG1JtvDjw/fXqwHmsXxMKxPM+auNeZmosHCuCPIIYWWIQjnECqobTjMLeVv8n857/+ZB7wFWxdexHWYE3WGlIDn/TjyUrNnt2taBGTUhg1pToukXktPB3hfcBC3TCZSG5wifUKqUt0VgXwU+FO4RTQxqGIsaINrzTHdalOGxAjIXEv5scERIwP+vuULUi/8XR+f0tZD9Vn7cGwd3KgZvBk/K5VFH2pUmz6yP6nw4nd7NXQmAIj++Um/zX3OrB88CoplrRYHtECiAbIm5TKyYc7kU9CPi/b0fpUDw5Q== ross.jones@digital.cabinet-office.gov.uk',
    ],
  }
}
