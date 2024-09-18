#!/bin/sh
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout config/ssl/sim.local.key -out config/ssl/sim.local.crt -config config/ssl/openssl.config