#!/bin/bash
# based on: https://docs.oracle.com/cd/E35976_01/server.740/es_admin/src/tadm_ssl_convert_pem_to_jks.html
export KEYSTORE_PASSWORD=almafa
if [ ! -f "fullchain1.pem" ]; then
	echo "Missing  fullchain1.pem."
	exit
fi
if [ ! -f "privkey1.pem" ]; then
	echo "Missing  privkey1.pem."
	exit
fi
set -o verbose
(cat fullchain1.pem; openssl rsa -in privkey1.pem -text) > eneCert.pem || exit # 0.
openssl pkcs12 -password pass:$KEYSTORE_PASSWORD -export -out eneCert.pkcs12 -in eneCert.pem || exit # 1.
keytool -storepass $KEYSTORE_PASSWORD -genkey -keyalg RSA -alias endeca -keystore truststore.ks -noprompt -dname "CN=this, OU=will, O=be, L=deleted, S=in_the, C=next_command" || exit # 3.a
keytool -storepass $KEYSTORE_PASSWORD -delete -alias endeca -keystore truststore.ks || exit # 3.b
keytool -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD -import -trustcacerts -alias endeca-ca -file eneCert.pem -keystore truststore.ks  -noprompt || exit # 4.
keytool -storepass $KEYSTORE_PASSWORD -genkey -keyalg RSA -alias endeca -keystore keystore.ks  -noprompt -dname "CN=this, OU=will, O=be, L=deleted, S=in_the, C=next_command"  || exit # 7.a
keytool -storepass $KEYSTORE_PASSWORD -delete -alias endeca -keystore keystore.ks || exit # 7.b
keytool -storepass $KEYSTORE_PASSWORD -importkeystore -srckeystore eneCert.pkcs12 -srcstoretype PKCS12 -destkeystore keystore.ks -deststoretype JKS  -noprompt || exit # 8.
# keystore.ks file successfully generated.
# cleanup
rm eneCert.pem truststore.ks eneCert.pkcs12