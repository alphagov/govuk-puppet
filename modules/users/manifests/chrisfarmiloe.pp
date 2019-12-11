# Creates the user chrisfarmiloe for Chris Farmiloe
class users::chrisfarmiloe {
  govuk_user { 'chrisfarmiloe':
    ensure   => absent,
    fullname => 'Chris Farmiloe',
    email    => 'chris.farmiloe@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/Ka7G1zRjwe2gbgIBCw+ye+zyi4EB76rCyr8SV64Sba763zsSbh5ath0XeDyjivK1wc4dkgQfJ3xvQV8yKQPRNzZLz8M2RFdTH88x4t4TUbeVHMRbNL/EuAPyIISqr2UZL1l8HpuvnZt0b+By2f3Qx1mODl4yKZ2nS75VeeoodnsEPfGjLDkzoWAmeHpJ7ZXHGHO/0qq1+gHAVWZHRATAnNXGZQGNQa0OfT43JW5Ze/uwaRRpUcFV7XPE33D40Ax4oUtW1wNlbg7/GSjEYJRmHKd/lt+DQewmc22dEwGhm7xPyLCRVNtLSTpMw6wig2McGCnNYYVRWMQS2EC/Jy6moYv7gS2pnqhYIH4OHHw3iVFMEBOdc5L5sceJviIGMP1Yv2XwaJiDM2yyE9qqgP7ONr68iX3EzermV3dyf2k9/xd8uvkGUTMaMaLBphiP8AO0uVv+dNSTeOn3i7CzYlySUSx9tUk6FSV9tTrNYhUnMdUWmHiK0SwR4Jbh5W5M+4sC8n9WTnefS6VneTybspfrV/0/9pJzdYtfyJ0FmsbkuV57uOWeHcZ78Flwga90yozjcOFrZnMTsxqPjzkigQZqPrGL0vyD6mTX3tP6sHo09j5stAb4FwdWXWKrgyob+knmumNSXEd8OWJmL0DttyO3Ai9gf/67GSB6OwLKj3Cp8w== cardno:000606447099',
    ],
  }
}
