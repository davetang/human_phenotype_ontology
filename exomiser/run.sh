#!/bin/bash

wget -c ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/exomiser-cli-7.2.1.sha256
wget -c ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/exomiser-cli-7.2.1-distribution.zip
wget -c ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/exomiser-cli-7.2.1-data.zip

sha256sum -c exomiser-cli-7.2.1.sha256
# exomiser-cli-7.2.1-distribution.zip: OK
# exomiser-cli-7.2.1-data.zip: OK

unzip exomiser-cli-7.2.1-distribution.zip
unzip -o exomiser-cli-7.2.1-data.zip

