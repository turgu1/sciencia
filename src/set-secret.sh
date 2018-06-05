#!/bin/bash

rm ~/Dev/sciencia/config/secrets.yml
echo "production:" > ~/Dev/sciencia/config/secrets.yml
echo "  secret_key_base: `bundle exec rake secret`" >> ~/Dev/sciencia/config/secrets.yml

echo "Done"
