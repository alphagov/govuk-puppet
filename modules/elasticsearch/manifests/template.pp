# == Type: elasticsearch::template
#
# Create an elasticsearch index template
#
# === Parameters
#
# [*template_name*]
#   The name of the template.

# [*content*]
#   The content to use to create the template. This should be a valid JSON
#   document. NB: This is a bit of a hack, and you should not have any single
#   quotes anywhere in your JSON document!
#
define elasticsearch::template (
  $content,
  $ensure = 'present',
  $template_name = $title
) {

  # Install a template using the es-template tool installed as part of
  # `estools` by the elasticsearch::package class.
  case $ensure {

    'present': {
      exec { "create-elasticsearch-template-${template_name}":
        command => "echo '${content}' | es-template create '${template_name}'",
        unless  => "echo '${content}' | es-template compare '${template_name}'",
        require => Class['elasticsearch::service'],
      }
    }

    'absent': {
      exec { "delete-elasticsearch-template-${template_name}":
        command => "es-template delete '${template_name}'",
        onlyif  => "es-template get '${template_name}'",
        require => Class['elasticsearch::service'],
      }
    }

    default: {
      fail("Invalid 'ensure' value '${ensure}' for elasticsearch::template")
    }

  }

}
