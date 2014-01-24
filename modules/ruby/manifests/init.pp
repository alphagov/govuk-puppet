class ruby {

  # FIXME: Prevent downgrading to the `ruby` metapackage containing an
  # older version of Ruby from Ubuntu's APT repository.
  # Our own internal Ruby package bears the same package name.
  if $::lsbdistcodename == 'lucid' {
    apt::pin { 'use_internal_ruby_if_lucid':
      packages   => 'ruby',
      version    => '1.9.2-p290',
      priority   => 1001, # 1001 will force a downgrade if necessary
    }
  }

}
