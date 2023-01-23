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
echo "\n\nSTEP 2 -  create a Self-signed Root certificate (ca-cert.pem) \n-----------------------------"
echo "generate a x509v3 CSR with the private key"
openssl req -new -nodes -key ca-pkey.pem -nameopt utf8 -utf8 -extensions req_ext -config caparam.cnf -out ca-csr.pem
echo "check the CSR attributes"
openssl req -text -in ca-csr.pem -noout
echo "ok\n-----------------------------"
echo "sign the x509v3 CSR with the private key to create the self signed certificate"
openssl x509 -req -in ca-csr.pem -days 31 -signkey ca-pkey.pem -set_serial 01 -extfile caparam.cnf -extensions ca_ext  > ca-cert.pem
#openssl x509 -req -in myCSR.csr -extfile v3.ext -CA myCA.crt -CAkey myCA.key -CAcreateserial -out userCertificate.crt  -days 365
echo "ok\n-----------------------------"
echo "check the CA cert attributes"
openssl x509 -text -in ca-cert.pem -noout
echo "ok\n-----------------------------"
echo "\n\nSTEP 3 - create 2 x509v3 CSR for client and server\n-----------------------------"
echo "generate x509v3 CSR for client"
#openssl req -out cli-csr.pem -key cli-pkey.pem -new -subj "/C=FR/ST=IDF/L=PARIS/O=VMWARE/OU=AVI/CN=client.certlab.avilab.top"
openssl req -new -nodes -key cli-pkey.pem -nameopt utf8 -utf8 -extensions req_ext -config cliparam.cnf -out cli-csr.pem
echo "ok\n-----------------------------"
echo "check the CSR client attributes"
openssl req -text -in ca-csr.pem -noout
echo "ok\n-----------------------------"
echo "generate x509v3 CSR for server"
openssl req -out srv-csr.pem -key srv-pkey.pem -new -subj "/C=FR/ST=IDF/L=PARIS/O=VMWARE/OU=AVI/CN=server.certlab.avilab.top"
openssl req -new -nodes -key srv-pkey.pem -nameopt utf8 -utf8 -extensions req_ext -config srvparam.cnf -out srv-csr.pem
echo "ok\n-----------------------------"
echo "check the CSR server attributes"
openssl req -text -in ca-csr.pem -noout
echo "ok\n-----------------------------"
echo "\n\nSTEP 4 - Sign the 2 CSR with the CA info (cert and pkey) and generate the 2 final signed certificates\n-----------------------------"
echo "sign the client CSR"
#openssl x509 -req -in cli-csr.pem -days 30 -CA ca-cert.pem -CAkey ca-pkey.pem -set_serial 01 > cli-cert.pem
openssl x509 -req -in cli-csr.pem -days 31 -CA ca-cert.pem -CAkey ca-pkey.pem -set_serial 01 -extfile caparam.cnf -extensions req_ext -out cli-cert.pem
rm cli-csr.pem
echo "-----------------------------"
echo "verify the client cert against CA"
openssl verify -verbose -CAfile ca-cert.pem cli-cert.pem
echo "-----------------------------\n"
echo "check the client cert attributes"
openssl x509 -text -in cli-cert.pem -noout
echo "-----------------------------\n"
echo "\nsign the server CSR"
#openssl x509 -req -in srv-csr.pem -days 30 -CA ca-cert.pem -CAkey ca-pkey.pem -set_serial 01 > srv-cert.pem
openssl x509 -req -in srv-csr.pem -days 31 -CA ca-cert.pem -CAkey ca-pkey.pem -set_serial 01 -extfile caparam.cnf -extensions req_ext -out srv-cert.pem
rm srv-csr.pem
echo "-----------------------------"
echo "verify the server against CA"
openssl verify -verbose -CAfile ca-cert.pem  srv-cert.pem
echo "-----------------------------"
echo "check the server cert attributes"
openssl x509 -text -in srv-cert.pem -noout
echo "ok\n-----------------------------"
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