#!/bin/bash
# Creates a self-signed code-signing certificate "DScribe Self-Signed" for release builds and prints
# the two GitHub secrets the release workflow uses. Run once; keep the .p12 somewhere safe — losing it
# means users re-grant Accessibility once after the next update.
set -euo pipefail
OUT="${1:-$HOME/.dscribe-signing}"; mkdir -p "$OUT"; cd "$OUT"
PASS=$(openssl rand -hex 16)
cat > cert.cnf <<CNF
[req]
distinguished_name=dn
x509_extensions=ext
prompt=no
[dn]
CN=DScribe Self-Signed
[ext]
basicConstraints=critical,CA:false
keyUsage=critical,digitalSignature
extendedKeyUsage=critical,codeSigning
CNF
openssl req -x509 -newkey rsa:2048 -nodes -days 3650 -keyout key.pem -out cert.pem -config cert.cnf
openssl pkcs12 -export -legacy -inkey key.pem -in cert.pem -name "DScribe Self-Signed" -out dscribe-signing.p12 -passout "pass:$PASS" 2>/dev/null \
  || openssl pkcs12 -export -inkey key.pem -in cert.pem -name "DScribe Self-Signed" -out dscribe-signing.p12 -passout "pass:$PASS"
rm -f key.pem cert.cnf
echo "$PASS" > password.txt; chmod 600 password.txt dscribe-signing.p12
echo "Created $OUT/dscribe-signing.p12"
echo "Set the GitHub secrets with:"
echo "  base64 -i $OUT/dscribe-signing.p12 | gh secret set SIGNING_CERT_P12"
echo "  gh secret set SIGNING_CERT_PASSWORD < $OUT/password.txt"
