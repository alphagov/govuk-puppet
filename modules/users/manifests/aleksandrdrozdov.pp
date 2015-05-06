# Creates the aleksandrdrozdov user
class users::aleksandrdrozdov {
  govuk::user { 'aleksandrdrozdov':
    fullname => 'Aleksandr Drozdov',
    email    => 'aleksandr.drozdov@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEIMlaMRa6b85UhGIU0ifG/GH/1836GixypMeA2vMsibjDEQJv5Di+xjhoKazRuX7byAPsd+U9R8Oe34YIodKCpBXS6ei1hH6plX3dgVHI/ThfW5gE7IHuXcHfKQxlGpemLU4cS+BlaAv8yibQej5AoSeLAORi94VWAyCiOffDtcyLGe/FVM8hDa6p48tSmW5WdzpbE5Q2ddgy8JHv3xd/RCqpajYpwQuwImr+vGIHidY2ElJu3ihtFYQjQHLtlRJ2stC8Ognr8j1kG0EoZAj0O3g5Yd1MQvN1FcfKj5gsSuNngh6b1kRqAZthY67pY03gbd5s4xxjOoSzgcVMD4DF',
  }
}
