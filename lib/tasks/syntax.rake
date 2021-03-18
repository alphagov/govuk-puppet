require 'puppet-syntax/tasks/puppet-syntax'

PuppetSyntax.exclude_paths = ["vendor/**/*"]
PuppetSyntax.hieradata_paths = [
  "**/data/**/*.yaml",
  "hieradata/**/*.yaml",
  "hiera*.yaml",
]
