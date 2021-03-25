#!/bin/bash

INDEX=$1

echo "########  PARAMETER   ########"
echo
echo "Index             = $INDEX"
echo
echo "########  EXECUTE         ########"
echo

./json/esbulk -setting -i $INDEX
./json/esbulk -alias -i $INDEX

###     SAMPLE
###     ./genOrganization.sh 51001

