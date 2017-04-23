export CERT_ROOT="/etc/ssl"
export KEY_PATH="$CERT_ROOT/private/key.pem"
export CERT_PATH="$CERT_ROOT/certs/cert.pem"

sudo rm $KEY_PATH
sudo rm $CERT_PATH