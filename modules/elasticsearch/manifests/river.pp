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
#   document.
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
      exec { "create-elasticsearch-river-${river_name}":
        command  => "es-river create '${river_name}' <<EOS
${content}
EOS",
        unless   => "es-river compare '${river_name}' <<EOS
${content}
EOS",
        # This is required to ensure the correct interpolation of variables in
        # the above commands.
        provider => 'shell',
        require  => Class['elasticsearch::service'],
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
