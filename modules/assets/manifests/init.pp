# == Class: assets
#
# Configures a machine ready to serve assets.
#
class assets (
  ) {

  unless $::aws_migration {
    include assets::user
  }
}
