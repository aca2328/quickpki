# Quickly create a PKI for mTLS testing
The objective here is to quickly create the needed certificate and CA to configure a mTLS connection between web client and a server ( here i'll use Avi networks , but any other server / solution will work also)

The script will create all certificates using ECC secp384r1 for keys, SHA265 for signature, x509v3 extensions to set CRL distribution point and multiple fqdn in Subject Alternative Name (SAN)

* certificate and private key generated for the CA : 
  - ca-cert.pem
  - ca-pkey.pem
  - ca.pfx
* certificate and private key for the Server, result of a CSR signed by the CA certificate and private key, serial numner generated in `.slr` file
  - srv-cert.pem
  - srv-pkey.pem
  - srv.pfx
  - srv.slr
* certificate and private key for the Client, result of a CSR signed by the CA certificate and private key, serial numner generated in `.slr` file
  - cli-cert.pem
  - cli-pkey.pem
  - cli.pfx
  - cli.slr

# Requirements and tests

* script to run on bash or zsh
* tested with openssl version 3.3.6 , macos 13.1, 
* ca cert upload tested on mac os 13.1, windows xx
* server certificate on AVI 22.1.2 version


# PKI generation

All files are there :[https://github.com/aca2328/quickpki]

1. Review and adjust some parameters in the tree `.cns` :

  - 'caparam.cnf' list the parameters used by openssl during CA certificate creation
  - 'srvparam.cnf' list the parameters used by openssl during Server certificate creation
  - 'cliparam.cnf' list the parameters used by openssl during Client certificate creation

2. Review some parameter in `certgen.sh` script

3. Add exec rights with `chmod+ax certgen.sh` before execution with `./certgen.sh`

* The script will create a folder with all the files, name of the folder is random so every time you run the script , it will create another folder.
* After each certificate creation, the script will issue a command to browse the attributes and a command to check signature calidity against the CA.

# Import the CA into worksatation

