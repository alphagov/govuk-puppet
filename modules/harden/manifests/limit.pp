# == Type: harden::limit
#
# Set a custom system limit. See limits.conf(5) for documentation of the
# limits file format.
#
# === Parameters
#
# [*domain*]
#   The user, group, or wildcard to which the limit should apply. For example,
#   "deploy", or "@staff", or "*".
#
# [*type*]
#   The type of limit to enforce: "hard", "soft", or "-" which sets both at
#   once.
#
# [*item*]
#   The limit to enforce, e.g. "nofile", or "memlock"
#
# [*value*]
#   The enforced value, e.g. "1024"
#
define harden::limit (
  $domain,
  $type,
  $item,
  $value
) {

  file { "/etc/security/limits.d/${domain}-${item}.conf":
    ensure  => 'present',
    content => "${domain} ${type} ${item} ${value}\n",
  }

}

