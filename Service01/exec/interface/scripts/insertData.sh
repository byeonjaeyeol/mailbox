#!/bin/bash

INDEX=$1
CI=$2
SUSINJA=$3

echo "########  PARAMETER   ########"
echo
echo "Index             = $INDEX"
echo "CI Number 	= $CI"
echo "Susinja Name      = $SUSINJA"
echo
echo "########  EXECUTE         ########"
echo

./json/esbulk -bulk -i $INDEX -c $CI -s $SUSINJA

###     SAMPLE
###     ./insertData.sh 51001 01048781233 박태검

