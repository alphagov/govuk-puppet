# Creating a user account

Follow these steps to get access to GOV.UK's environments (integration, staging and production).

The list of users for integration is in hieradata in this repo. The list of users for staging
and production is in the private govuk-secrets repo.

Once you've made a pull request and somebody has merged it to master, it will automatically
deploy to integration within a few minutes.

## Create an SSH key

In [`modules/users/`][users] create a manifest file for yourself. There are
[specs for SSH key strength][users-spec] so make sure your key meets the requirements.

[users]: https://github.com/alphagov/govuk-puppet/tree/master/modules/users/manifests
[users-spec]: https://github.com/alphagov/govuk-puppet/blob/master/modules/users/spec/classes/users_spec.rb

## Add yourself to the list of users

Add the name of your manifest (your username) into the list of `users::usernames` in hieradata/integration.yaml.

## CI and Integration access

There's a GitHub team called 'GOV.UK' that you should be added to in order
to see the CI and integration environments. GitHub owners (your team's tech
lead is probably one) can do this for you.

## Staging and production access

If you're getting access to staging and production, repeat the above step,
specifying the 'GOV.UK Production' team. You'll also need to add yourself to
`ssh::config::allow_users` and `users::usernames` in those environments (hieradata can be found in
`govuk-secrets`) to be able to SSH to machines.

Talk to the GOV.UK Platform Operations Manager about when you need to have production access.
