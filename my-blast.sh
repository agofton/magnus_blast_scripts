#!/bin/bash

# Input from command line / environment variables

files="${BASH_ARGV[@]}"
nfiles=${#BASH_ARGV[@]}
db=`basename ${MY_BLAST_DB}`

echo ""
echo "Blast with               ${MY_BLAST}"
echo "Blast arguments          ${MY_BLAST_ARGS}"
echo "Number of threads        ${MY_BLAST_THREADS}"
echo "Path to database is      ${MY_BLAST_DB}"
echo "Database name is         ${db}" 
echo "Number of query files    $nfiles"

# Stage database to /tmp
# We have a maximum of 64 GB to play with, so the complete database should
# not execeed, say, 32 GB in size

echo ""
echo "Staging database to /tmp"

STARTTIME=$(date +%s)
cp ${MY_BLAST_DB}* /tmp
ENDTIME=$(date +%s)

echo "Time to stage database   $(($ENDTIME-$STARTTIME)) s"

# For each input file

while [ $nfiles -gt 0 ]; do

    ((nfiles-=1))
    f="${BASH_ARGV[$nfiles]}"

    STARTTIME=$(date +%s)

    stub=`echo $f | sed 's/.fa$//'`

    echo ""
    echo "-> Input  ${f}"
    echo "-> Output ${stub}.blast"

    output=${stub}.blast
    ${MY_BLAST} ${MY_BLAST_ARGS} -num_threads ${MY_BLAST_THREADS} -query ${f} -db /tmp/${db} -out ${output}

    ENDTIME=$(date +%s)

    echo "-> Time to blast $f   $(($ENDTIME-$STARTTIME)) s"
done

echo ""
echo "Unstage database..."

rm -f /tmp/*

echo "Finished normally."
