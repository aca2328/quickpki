# Quickly create a PKI for mTLS testing

The objective here is to quickly create the needed certificate and CA to configure a mTLS connection between web client and a server ( here i'll use Avi networks , but any other server / solution will work also)

The script will create all certificates using ECC secp384r1 for keys, SHA265 for signature, x509v3 extensions to set CRL distribution point and multiple fqdn in Subject Alternative Name (SAN)

* certificate and private key generated for the CA :
  * ca-cert.pem
  * ca-pkey.pem
  * ca.pfx
* certificate and private key for the Server, result of a CSR signed by the CA certificate and private key, serial numner generated in `.slr` file
  * srv-cert.pem
  * srv-pkey.pem
  * srv.pfx
  8 srv.slr
* certificate and private key for the Client, result of a CSR signed by the CA certificate and private key, serial numner generated in `.slr` file
  * cli-cert.pem
  * cli-pkey.pem
  * cli.pfx
  * cli.slr

# Requirements and tests

* script to run on bash or zsh
* tested with openssl version 3.3.6 , macos 13.1,
* ca cert upload tested on mac os 13.1, windows xx
* server certificate on AVI 22.1.2 version

# PKI generation

All files are there ![quickpki}(https://github.com/aca2328/quickpki)

1. Review and adjust some parameters in the tree `.cns` :
* `caparam.cnf` list the parameters used by openssl during CA certificate creation
* `srvparam.cnf` list the parameters used by openssl during Server certificate creation
* `cliparam.cnf` list the parameters used by openssl during Client certificate creation

2. Review some parameter in `certgen.sh` script

3. Add exec rights with `chmod+ax certgen.sh` before execution with `./certgen.sh`

* The script will create a folder with all the files, name of the folder is random so every time you run the script , it will create another folder.
* After each certificate creation, the script will issue a command to browse the attributes and a command to check signature calidity against the CA.

# Import the CA into macos worksatation

for Macos, click on `ca-cert.pem` file, it will appear in the `keychain access` tool as an untrusted certificate named with the common name listed in the `caparam.cnf`.

Right click `Get info` on the certificate, then manually force the trust.
![untrustedmac](/images/untrustedmac.png)

The certificate should appear as manually trusted
![trustedmac](/images/trustedmac.png)

# Import the CA into windows worksatation
\
.

# Use the server certificate with NSX ALB ( AVI )

from AVI UI, go to `Template / Security / SSL/TLS` :
* choose `create a certificate / Root/Intermetiade CA`
* name it and import `ca-cert.pem` file

you should get green light here.\
![greenroot](/images/greenroot.png)

Now add the server certificate by choosing `certificate / application Certificate`
* name it and choose import type
* import the `srv.pfx` file into section `Upload or Paste Key (PEM) or PKCS12 File`, using the password setted initially in `srvparam.cnf` file.

After validation you should get another green light with mention of the SSL certificate chain that lead to the root certificate imported above.

Final step is just to add the certificate to the virtual service.

Test standard TLS with server certificate mode by browsing from a worksation configured with the root certificate to the service, using either dns name or ip ( on or the two values must match the configured values in `srvparam.cnf` file setion [ALT names].

here you sould get a lock with indication that the connection is secure. 
![securetls](/images/securetls.png)
