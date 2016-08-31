# Creating a user account

Follow these steps to get access to GOV.UK's environments (integration, staging and production).

The list of users for integration is in hieradata in this repo. The list of users for staging
and production is in the private deployment repo.

Once you've made a pull request and somebody has merged it to master, it will automatically
deploy to integration within a few minutes.

## Create an SSH key

In [`modules/users/`][users] create a manifest file for yourself. There are
[specs for SSH key strength][users-spec] so make sure your key meets the requirements.

[users]: https://github.com/alphagov/govuk-puppet/tree/master/modules/users/manifests
[users-spec]: https://github.com/alphagov/govuk-puppet/blob/master/modules/users/spec/classes/users_spec.rb

## Add yourself to the list of users

Add the name of your manifest (your username) into the list of `users::usernames` in hieradata/integration.yaml.

## Add yourself to the list of Jenkins users

There's another bit of hieradata in integration.yaml for `govuk_jenkins::config::admins` which will give you access to the deployment Jenkins. Add your github enterprise username (usually your full name) to this list.

## Staging and production

If you're getting access to staging and production, repeat the above hieradata changes in
the deployment repo. You'll also need to add yourself to `ssh::config::allow_users` in those
environments to be able to SSH to machines.

Talk to the GOV.UK Platform Operations Manager about when you need to have production access.
