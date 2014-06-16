# This class is empty. It only exists to pass an empty user list
# to `users` via hiera and acts as a safety measure to prevent passing
# a blank array of user groups.

# If you deliberately want to add no users, you must have the following
# set in hiera to avoid a catalog compile error:
#
#   users::user_groups:
#           - 'none'
class users::groups::none {
}
