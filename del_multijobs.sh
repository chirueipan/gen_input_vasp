#!/bin/bash
echo "You are going to delete a number of jobs"
read -p "Input the first job ID: " starting
read -p "Input the last job ID:" ending

until [ "$starting" -gt "$ending" ]
do
qdel $starting
starting=$(echo "$starting+1"|bc)
done
