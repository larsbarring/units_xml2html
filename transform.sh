#!/bin/bash

for x in base derived accepted; do
    xsltproc udunits2-general.xslt  udunits2-$x.xml > udunits2-$x.html
done