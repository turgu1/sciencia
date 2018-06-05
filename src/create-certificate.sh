#!/bin/bash

if [[ -e 'nginx-selfsigned.crt' && -e 'nginx-selfsigned.key' ]]; then

	echo "Certificate already exists... exiting"

else

	echo ""
	echo "Creating the nginx selfsigned certificate (good for 10 years)."
	echo "Please pay attention to the 'Common Name (Server FQDN)' prompt."
	echo "You must enter the IP address of the server machine:"
	echo ""

	openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt

fi