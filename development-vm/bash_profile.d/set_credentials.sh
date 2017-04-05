# Purpose: Handy way to store AWS credentials securely. 
# Usage:
#
# 1. Create a credentials.sh file containing the following, filling in the ? appropriately: 
#   export AWS_ACCESS_KEY_ID=? AWS_EC2_REGION=? AWS_SECRET_ACCESS_KEY=? DYNECT_PASS=? DYNECT_USER=?
# 2. Encrypt this file using gpg symmetric encryption and a STRONG passphrase
#   $ gpg -c credentials.sh
# 3. make sure to remove the unecrypted file afterwards:
#   $ rm -f credentials.sh
#
# You can then set the credentials using the sc alias:
#   $ sc
#   Enter passphrase: *****
# 

alias set_credentials='`gpg -d ~/credentials.sh.gpg`'
alias sc='set_credentials'
