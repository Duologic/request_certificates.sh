Request Let's Encrypt certificates with Lego
============================================

Automation script for requesting Let's Encrypt certificates with [Lego](https://github.com/xenolf/lego) using a simple TXT record and DNS-01 (via AWS Route53).

The script can be improved by allowing more DNS providers supported by Lego. Please share your code.

Dependencies
------------

* bash (or similar)
* wget
* tar
* dig

Usage
-----

1. Create a TXT record with one domain per line
1. Get AWS credentials that can access Route53 for those domains
1. Run the script:

        ./request_certificates.sh <TXT record> <AWS_ACCESS_KEY_ID> <AWS_SECRET_ACCESS_KEY> <LE_EMAIL>

Example
-------
    ./request_certificates.sh ssldomains.example.com AAAAAAAAAAAAAAAAAAAA 9OZo3Hzic5EwPGLEXAMPLE3YA7aafZi5SPcS1hI8j ohn@example.com
