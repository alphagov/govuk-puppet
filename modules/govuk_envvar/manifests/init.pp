# govuk_envvar
#
# Defines a global GOV.UK environment variable, which will be exported for all
# applications when using govuk_spinup or govuk_setenv.
#
# NB: most applications will alter their behaviour on the basis of the value
# of govuk_envvars, but there is no explicit dependency encoded here. You may
# need to restart an application before it picks up a changed environment
# variable.

define govuk_envvar ($value = undef, $envdir = '/etc/govuk/env.d', $varname = $title) {

  file { "${envdir}/${varname}":
    content => $value,
  }

}
