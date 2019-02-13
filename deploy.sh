#!/bin/bash
jekyll b
rsync -avr --delete-after --delete-excluded _site/ manuel@dbis-ci.informatik.uni-kl.de:/srv/clash-doc/
