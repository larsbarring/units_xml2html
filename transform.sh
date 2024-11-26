#!/bin/bash

for x in base derived accepted; do
    xsltproc xml2html.xslt  udunits2-$x.xml > udunits2-$x.html
done