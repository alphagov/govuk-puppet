# Creates the mattbostock user
class users::mattbostock {
  govuk_user { 'mattbostock':
    fullname => 'Matt Bostock',
    email    => 'matt.bostock@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBc1Tcz6UiZoCnQCadVCSuJT9UXu0sf/duILN5epB2s0jL1uB8rKjT+RrpstZAr5YIN3Gm2IpTlTAxftNyDnxH5SqFYt4lLG+ibCxGffUYdJt0RCc4Atgh7VJDtLiwLbH1iaAVCipV8SevkcbT1BaBymsIPqy76XtuI46ENTbT23wW9a3F6j43M0TMzjFsTVy4dagSkkpb3V47E26jik/rcVL43lZNyaLBx/Nn/4bdGjZw6LfjyTAyE//xTvK5I6dYLFF4hH9IwC59Hs532q73YjXsEey4hf+mPjZWjirIJdyisXyK4E1LfKTqQoqOd2mMiPlK15pkDkHc1DnZTv8AZCgWNf87li2GIAsuB62bR76Umg7U49J+hFN6TSs8kLB+QJg83BBnKUb4lJj49BCGg7VP6xx7VIuG6ir/WROmN33miKpYBE8NYZb1t7W/CeglcfA3eZh+ZZAvQ8AUDh7WHvxqr0L5UQuuVCtO4pJV0OyKorLM/5TYh++CKr0Z+EZAVK3WsB+EIPbT9lNy0FrY40GAfE2Ud4uW5P20afYnd+f2TfBotRC6EHtM8guqO8JoFUqWTCgcyQyEe3f4zR5x7jseGyb/hL+dOPgfw3WNVYdLKNQx9weEjRAVhlzfDOrfOXEdPoaOYKmtWd2i4yM0/wblxOQnxI4rZbo1KWBx2Q== matt.bostock@digital.cabinet-office.gov.uk',
  }
}
