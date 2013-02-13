# == Type: elasticsearch::river
#
# Create an elasticsearch river
#
# === Parameters
#
# [*river_name*]
#   The name of the river.

# [*content*]
#   The content to use to create the river. This should be a valid JSON
#   document. NB: This is a bit of a hack, and you should not have any single
#   quotes anywhere in your JSON document!
#
define elasticsearch::river (
  $content,
  $ensure = 'present',
  $river_name = $title
) {

  # Install a river using the es-river tool installed as part of
  # `estools` by the elasticsearch::package class.
  case $ensure {

    'present': {
      if $content =~ /'/ {
        fail('Sorry, but you cannot have single quotes in your elasticsearch::river content')
      }
      exec { "create-elasticsearch-river-${river_name}":
        command => "echo '${content}' | es-river create '${river_name}'",
        unless  => "echo '${content}' | es-river compare '${river_name}'",
        require => Class['elasticsearch::service'],
      }
    }

    'absent': {
      exec { "delete-elasticsearch-river-${river_name}":
        command => "es-river delete '${river_name}'",
        onlyif  => "es-river get '${river_name}'",
        require => Class['elasticsearch::service'],
      }
    }

    default: {
      fail("Invalid 'ensure' value '${ensure}' for elasticsearch::river")
    }

  }

}
