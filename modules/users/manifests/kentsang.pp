# Create the kentsang user
class users::kentsang {
  govuk_user { 'kentsang':
    fullname => 'Ken Tsang',
    email    => 'ken.tsang@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7b3NnBnUVDh9fDud8HtxJ8KKL+EeHKNomIrurFZ716G3j00FHX3igkFVILQKJ5B5aZAwpwHcIWDkoRd4VItUAhfWIHndLFb86A+c+YADQHqCeNIzOLUg4Qac6YTGY64iFfDSuox6UHRLK5k/JrmGAYQWsrhUivsezu3Xjab/r5dTjcLiOeSLqInrNqusvYKfU39ZS6sewpOXULEyAnb+n11QP+1EiMtRP1dpxZWxOLFjHnXKDzO0CWDm2VNquFK8C85gnFZ6bsfz7JPnpO18eh2PIZNgyo7sWjd3iArBHhZeflgmjnBJBEeeGYCE92wnuFvjdRfyhOAbMZmKSW44R7u1h5QsB3rkUp5kgha5hAfmNRO+ww25U0Fn+L1f6fHBoSlyfXy6AQuGNZw+zkIfNOLleABToH6zDWMLIJOWly85wWdpABWjQ3siekOgCyhblU1cORgGiOAPHriQz8caYGB2LkSMZ2TY2odseWDqLSe0x2XBu+XNbuJFK+hnkcoVjLcaeYDCN2T2aQnhhhbY22BTkA729LyS+V1O7vNWL8/CrBvLtGNgraz/bv+6l4x/Cuj4pqRBanMWBbfL276O3HEd4Y2psWRlTXhqBXOsfeyFavBP8KkPO5wqutg13Ncgy7Vo2bfKafou89jMYoe4gqC8ZL01I6Od9SDFbgXhMdQ== ken.tsang@digital.cabinet-office.gov.uk',
  }
}
