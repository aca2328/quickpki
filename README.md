# Quickly create a PKI for mTLS testing
The objective here is to quickly create the needed certificate and CA to configure a mTLS connection between web client and a server ( here i'll use Avi networks , but any other server / solution will work also)

The script will create all certificates using ECC secp384r1 for keys, SHA265 for signature, x509v3 extentions to set CRL distribution point and multiple fqdn in Subject Alternative Name ( SAN)

https://github.com/aca2328/quickpki

# Requirements and tests

* script run in bash or zsh
* tested with openssl version 3.3.6 
* ca cert upload in mqc os ventura , windows xx
* server certificate on AVI 22.1.2 version


# setup and run

.cns extention files will setup the parameters needed for openssl command to run in non interactive mode.
you may need to change some values to fit you needs, below is the  list of the useful ones:
* 1
* 2
gencert.sh is the script to lauch using `./gencert.sh`