class mongodb::signing_key {
  include apt
  apt::deb_key { '7F0CEB10': }
}
