# This class is empty. It only exists to pass an empty user list
# to `users` via hiera and acts as a safety measure to prevent passing
# a blank array of user groups and then removing user accounts

# If you deliberately want to add no users and purge existing ones, you
# must have the following set in hiera:
#
#   users::user_groups:
#           - 'none'
class users::groups::none {
}
