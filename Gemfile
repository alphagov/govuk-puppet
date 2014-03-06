source "https://rubygems.org"

gem "rake"
gem "puppet-syntax"
gem "puppet-lint"
gem "puppet", "3.2.2"
gem "rspec-puppet"
# FIXME: There is some confusion about who should require who.
# https://github.com/rodjek/rspec-puppet/issues/56
gem "puppetlabs_spec_helper"

# FIXME: Revert to using the published Gem once d6dfc04 exists in a published version
# This is to allow empty default values when testing Hiera lookups
gem "hiera-puppet-helper", :git => 'git://github.com/alphagov/hiera-puppet-helper.git', :branch => 'v1.0.1-empty-hash-cherrypick'

gem "parallel_tests"
gem "parallel"
gem "librarian-puppet"
