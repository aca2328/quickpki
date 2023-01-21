#--- proc cert generation EC
echo "\n\nSTEP1 - create the 3 private keys: CA, Client and Server\n-----------------------------"
echo "creating the Certificate authority private key: ca-pkey.pem"
openssl ecparam -name secp384r1 -genkey -noout -out ca-pkey.pem
echo "ok\n-----------------------------"
echo "create the client private key: cli-pkey.pem"
openssl ecparam -name secp384r1 -genkey -noout -out srv-pkey.pem
echo "ok\n-----------------------------"
echo "create the server private key: srv-pkey.pem"
openssl ecparam -name secp384r1 -genkey -noout -out cli-pkey.pem
echo "ok\n-----------------------------"

echo "\n\nSTEP2 -  create a public certificate ca-cert.pem using the CA private key\n-----------------------------"
openssl req -new -x509 -nodes -days 10 -key ca-pkey.pem -subj "/C=FR/ST=IDF/L=PARIS/O=VMWARE/OU=AVI/CN=certlab.avilab.top" > ca-cert.pem
echo "ok\n-----------------------------"

echo "\n\nSTEP3 - create 2 CSR for client and server, based on the private keys key\n-----------------------------"
echo "generate cert request (CSR) for client,"
openssl req -out cli-csr.pem -key cli-pkey.pem -new -subj "/C=FR/ST=IDF/L=PARIS/O=VMWARE/OU=AVI/CN=client.certlab.avilab.top"
echo "ok\n-----------------------------"
echo "generate cert request (CSR) for server,"
openssl req -out srv-csr.pem -key srv-pkey.pem -new -subj "/C=FR/ST=IDF/L=PARIS/O=VMWARE/OU=AVI/CN=server.certlab.avilab.top"
echo "ok\n-----------------------------"

echo "\n\nSTEP 4 - Sign the 2 CSR with the CA info (cert and pkey) and generate the 2 final signed certificates\n-----------------------------"
echo "sign the client CSR"
openssl x509 -req -in cli-csr.pem -days 30 -CA ca-cert.pem -CAkey ca-pkey.pem -set_serial 01 > cli-cert.pem
rm cli-csr.pem
echo "-----------------------------"
echo "verify the cert against CA"
openssl verify -verbose -CAfile ca-cert.pem  cli-cert.pem
echo "-----------------------------"
echo "sign the server CSR"
openssl x509 -req -in srv-csr.pem -days 30 -CA ca-cert.pem -CAkey ca-pkey.pem -set_serial 01 > srv-cert.pem
rm srv-csr.pem
echo "-----------------------------"
echo "verify the cert against CA"
openssl verify -verbose -CAfile ca-cert.pem  srv-cert.pem
echo "-----------------------------"

echo "\n\nSTEP 5 - create pfx files for easy import\n-----------------------------" 
echo "adding Certificate authority cert and pkey in a pfx enveloppe, using password 'avi123'"
openssl pkcs12 -export -in ca-cert.pem -inkey ca-pkey.pem -out CA.pfx -password pass:avi123
echo "ok\n-----------------------------"
echo "adding Client cert and pkey in a pfx enveloppe, using password 'avi123'"
openssl pkcs12 -export -in cli-cert.pem -inkey cli-pkey.pem -out cli.pfx -password pass:avi123
echo "ok\n-----------------------------"

echo "adding Server cert and pkey in a pfx enveloppe, using password 'avi123'"
openssl pkcs12 -export -in srv-cert.pem -inkey srv-pkey.pem -out srv.pfx -password pass:avi123
echo "ok\n-----------------------------"

echo "moving final files into one folder\nend of processing"
folder=$(date +%m%s)
mkdir $folder
mv *.pem $folder
mv *.pfx $folder
echo "\nfolder name: $folder\n"
ls -ltr $folder