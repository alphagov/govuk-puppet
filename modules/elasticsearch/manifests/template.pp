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
#   document.
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
        command  => "es-template create '${template_name}' <<EOS
${content}
EOS",
        unless   => "es-template compare '${template_name}' <<EOS
${content}
EOS",
        # This is required to ensure the correct interpolation of variables in
        # the above commands.
        provider => 'shell',
        require  => Class['elasticsearch::service'],
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
