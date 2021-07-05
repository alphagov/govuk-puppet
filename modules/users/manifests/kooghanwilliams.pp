# Creates the Kooghan Williams user
class users::kooghanwilliams {
  govuk_user { 'kooghanwilliams':
    fullname => 'Kooghan Williams',
    email    => 'kooghan.williams@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAjCpUwnbRmm/GhCZxvBK/RIxq+LKrGNd3uHHeuQh4Sk+smt32+vioDgU1NCx7M7ckuS3FAqttVbDyHgPrj7BeZhfl5ayQwd6q0/z9fH0CpP7Ejn5TpeVoQsI/5qHqbZvPgbghJrcgiRHdOLtdEmUKOPLNfZN8skq6Q7AUSrLY02dBCkNcg3Or5iKHh6r95CAwfpsDrOoAhgmfBRqkRmWuZJkhYo/fajmLoI5/mvCqvI0NSdpDEBv150RT5jKCHQUDk2BlWN76x+TrN56yGppgru+n8rrvOQNL9h/flENjyTiAXcfVI36orPiz5kX7kDKkkFqcg5s+c2K+nPWYG9bmpqNjUX2e79LTu9JKawDXJipK6AW/1z2awMRLtUx1fm8/LacXeyzftk1uyMGgTMXLR8wwnNpQ7pmF/2ylndW/TGPIUHr5Lmqj4eIzbVzW0Paxl5xp6iuAYj1mGzh221GogX3C0EOxKChrIYXhKMQBbHZuiPFvqMz7MHO9+CLjwuP2iWMF+7c8iFDhumEFeXVWU3TNKedcc+8LWTMkeVsHu5AJZoAFb6o4Xp5W9buWQO24OzKwS0rGcSgrV5LpCF1/fFOyCTaz7OKV7juPJOzUCVJoIuyBG7cTXfZT0fotX5hqIq75Ys4R1lZUjYAsqbqCiDVerKVezBKv6SkJ93szWHM= GDS_public_4096',
  }
}
