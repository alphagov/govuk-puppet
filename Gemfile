source "http://rubygems.org"

gem "rake"
gem "puppet-lint"
gem "puppet", "2.7.19"
gem "rspec-puppet"
gem "parallel_tests"
gem "parallel"
gem "librarian-puppet"

# Projects that exist within this repo but not day-to-day dependencies.
# This is used by tools/puppet-apply-dev to prevent installing extraneous
# stuff. However be aware that it will persist to .bundle/config
group :subprojects do
  # Mirrorer
  gem "webmock"
  gem "mechanize"
  gem "spidey"
end
