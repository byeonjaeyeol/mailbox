#!/bin/bash

INDEX=$1

echo "########  PARAMETER ########"
echo
echo "Index             = $INDEX"
echo
echo "########  EXECUTE ########"
echo
./json/esbulk -ingest -i $INDEX


###     SAMPLE
###     ./setDefault.sh 51001

