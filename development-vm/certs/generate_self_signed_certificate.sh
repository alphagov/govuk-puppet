export CERT_ROOT="/etc/ssl"
export KEY_PATH="$CERT_ROOT/private/key.pem"
export CERT_PATH="$CERT_ROOT/certs/cert.pem"

if [ -e $KEY_PATH ] && [ -e $CERT_PATH ]
then
  echo "Self-signed certificate found, skipping creation."
else
  echo "Generating self-signed certificates."
  sudo openssl req -x509 -newkey rsa:4096 -keyout $KEY_PATH -out $CERT_PATH -days 365 -nodes -config auto_cert_config &> auto_cert_generation.log
fi
