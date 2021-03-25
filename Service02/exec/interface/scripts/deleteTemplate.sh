#!/bin/bash

INDEX=$1

echo "########  PARAMETER ########"
echo
echo "Index             = $INDEX"
echo
echo "########  EXECUTE ########"
echo
./json/esbulk -delete -i $INDEX


###     SAMPLE
###     ./deleteTemplate.sh 51001

