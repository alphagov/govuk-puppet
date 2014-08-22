# Creates the paulhayes user
class users::paulhayes {
  govuk::user { 'paulhayes':
    fullname => 'Paul Hayes',
    email    => 'paul.hayes@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiDv8KZouXdyNXeVuBbUdbGrcEVdVSwnAUWaUZTDepoBg6SzQ1zGf76k8qig70BT6MAAMSG13UU+h6QJTrK17vF2i9OBoKX2QQMs91jEVfXg24miIBoH8s/prHJ66i5B4OkBcKIY4VAaM/OAWggUDeUpUoYvAazXThaiQwC4VORFMQhVa+Vp8oluHtvuwcFgwA8PH4sYf6p1EFLRQfSk8XNBOYuTaCBLU9liUeVhP1msae60I4NHYnAJqmz4rsFUBeZ1lTclqZbUdrCWt1UH0+83a6i9rNINvMyGMgOWIco+vEHuLEeAts/qXFYc+bk0KV/8FQyd9Ogp4ggYuRh6YR',
  }
}
