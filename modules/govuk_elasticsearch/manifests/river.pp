# == Type: govuk_elasticsearch::river
#
# Create an elasticsearch river
#
# === Parameters
#
# [*river_name*]
#   The name of the river.
#
# [*content*]
#   The content to use to create the river. This should be a valid JSON
#   document.
#
define govuk_elasticsearch::river (
  $content,
  $ensure = 'present',
  $river_name = $title
) {

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
        require  => Class['govuk_elasticsearch::estools'],
      }
    }

    'absent': {
      exec { "delete-elasticsearch-river-${river_name}":
        command => "es-river delete '${river_name}'",
        onlyif  => "es-river get '${river_name}'",
        require => Class['govuk_elasticsearch::estools'],
      }
    }

    default: {
      fail("Invalid 'ensure' value '${ensure}' for govuk_elasticsearch::river")
    }

  }

}
