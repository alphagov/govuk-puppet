module Puppet::Parser::Functions
  newfunction(:govuk_check_user_naming, :doc => <<EOS
Verify that a govuk::user resource conforms to naming policy.
EOS
  ) do |args|
    unless args.size == 3
      raise(ArgumentError, "govuk_check_user_naming: wrong number of arguments given #{args.size} for 3")
    end

    uname, fname, email = args
    return if user_in_whitelist?(uname)

    uname_from_email = email.split('@').first.split('.').join.gsub(/[^a-z]/i, '')
    uname_from_full = fname.downcase.split(' ').join.gsub(/[^a-z]/i, '')

    unless uname == uname_from_full
      raise(Puppet::Error, "govuk_check_user_naming: expected username '#{uname}' to be '#{uname_from_full}' based on fullname")
    end

    unless uname == uname_from_email
      raise(Puppet::Error, "govuk_check_user_naming: expected username '#{uname}' to be '#{uname_from_email}' based on email")
    end
  end
end

def user_in_whitelist?(username)
  # Non-human system accounts.
  return true if %w{
    govuk-crawler
    govuk-backup
    govuk-netstorage
  }.include?(username)

  # Existing humans. Do NOT add to this list.
  return true if %w{
    ajlanghorn
    alex_tea
    alext
    benilovj
    benp
    bob
    bradleyw
    dai
    davidt
    dcarley
    elliot
    futurefabric
    garethr
    heathd
    jabley
    jackscotti
    james
    jamiec
    jordan
    joshua
    kushalp
    minglis
    mwall
    niallm
    ollyl
    ppotter
    psd
    roc
    rthorn
    ssharpe
    tekin
    vinayvinay
  }.include?(username)

  return false
end
