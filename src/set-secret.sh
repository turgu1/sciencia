#!/bin/bash

if [ -e ~/Dev/sciencia/config/secrets.yml ]; then
	rm ~/Dev/sciencia/config/secrets.yml
fi

key=`ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"`

echo "production:" > ~/Dev/sciencia/config/secrets.yml
echo "  secret_key_base: ${key}" >> ~/Dev/sciencia/config/secrets.yml

echo "Done"
