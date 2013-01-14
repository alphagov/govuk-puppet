This inhouse module supersedes [maestrodev/wget](https://forge.puppetlabs.com/maestrodev/wget) from Librarian.

They are mostly like-for-like except for our requirement to specify a
version. A pull request has been submitted upstream:

- https://github.com/maestrodev/puppet-wget/pull/3

Once merged we can wrap this in something like a `govuk::wget` helper class
that pulls in the repository and provides the appropriate version.
