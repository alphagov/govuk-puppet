# == Define: icinga::servicegroup_members
#
# Most of these params relate to Nagios service configuration directives:
#
# https://icinga.com/docs/icinga1/latest/en/objectdefinitions.html#servicegroup
#
# === Parameters:
#
# [*ensure*]
#   Can be used to remove an existing servicegroup.
#   Default: present
#
# [*servicegroup_name*]
#   The name of the servicegroup. Note this is different to the title of the
#   resource, which has to be unique for each node it's declared on.
#
define icinga::servicegroup_members (
  $ensure = 'present',
  $servicegroup_name = undef,
) {
  $name_underscore = regsubst($servicegroup_name, '\.', '_', 'G')

  $servicegroup_filename = "/etc/icinga/conf.d/icinga_servicegroup_${name_underscore}.cfg"

  if $ensure == 'present' {
    $servicegroup_content = template('icinga/servicegroup.erb')

  } else {
    $servicegroup_content = ''
  }

  ensure_resource('file', $servicegroup_filename, {'content' => $servicegroup_content})
}
