#!/bin/bash 
 
echo -------------------------------------------------------------------------------------------
echo Enter your Graph ID
echo -------------------------------------------------------------------------------------------
echo "Go to your graph settings in https://studio.apollographql.com/"
echo "then copy your Graph ID and enter it at the prompt below."
read -p "> " graph
if [[ -z "$graph" ]]; then
    >&2 echo "Error: no graph ID specified."
    exit 1
fi

export graph=$graph
