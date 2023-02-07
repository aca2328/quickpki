# Quickly create a PKI for mTLS testing
The objective here is to quickly create the needed certificate and CA to configure a mTLS connection between web client and a server ( here i'll use Avi networks , but any other server / solution will work also)

The script will create all certificates using ECC secp384r1 for keys, SHA265 for signature, x509v3 extentions to set CRL distribution point and multiple fqdn in Subject Alternative Name ( SAN)

* certificate and private key for the CA
* certificate and private key for the Server, CSR signed by the CA certificate and pricate key
* certificate and private key for the Client, CSR signed by the CA certificate and pricate key


[https://github.com/aca2328/quickpki]

# Requirements and tests

* script to run on bash or zsh
* tested with openssl version 3.3.6 , macos 13.1, 
* ca cert upload tested on mac os 13.1, windows xx
* server certificate on AVI 22.1.2 version


# setup and run

.cns extention files will setup the parameters needed for openssl command to run in non interactive mode.

'caparam.cnf' list the parameters used by openssl during CA certificate creation
'srvparam.cnf' list the parameters used by openssl during Server certificate creation
'cliparam.cnf' list the parameters used by openssl during Client certificate creation



you may need to change some values to fit you needs, below is the  list of the useful ones:

[ req_distinguished_name ]
commonName = 'your domain'
countryName = 
stateOrProvinceName = 
localityName = 
organizationName =
organizationalUnitName =




* 2

* gencert.sh is the script to lauch using `./gencert.sh`
* it will create a folder with all the files, name of the folder is random so every time you run the script , it will create another folder
