# Contributing guidelines for GOV.UK's Puppet repository

## Coding in the open vs open source

This repository is [public][coding-open], but it's not supported open
source software. We may not accept contributions if they aren't useful
for GOV.UK or if they introduce operational complexity.

[coding-open]: https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/

## Pull requests

You can propose changes using a pull request.

1. [Fork the repository][forking] (if you don't have access to push new branches)
2. Create a feature branch to work on (`git checkout -b my-new-feature`)
3. Commit your work (we like [commits that explain your thought process][commits])
4. Open a pull request
5. If you have write access, you can merge your own pull request once somebody
   has approved it. If you don't have access, we'll merge the pull request for
   you once it's ready.

[forking]: https://help.github.com/articles/fork-a-repo/
[commits]: https://github.com/alphagov/styleguides/blob/master/git.md

## Tests

Our tests run on our own Jenkins instance. This is restricted to
branches in the `alphagov` GitHub org. We have [a process for
running our CI checks on external contributors PRs](pr-process).

[pr-process]: https://docs.publishing.service.gov.uk/manual/merge-pr.html#a-change-from-an-external-contributor
