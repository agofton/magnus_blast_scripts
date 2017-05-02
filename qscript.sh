#!/bin/bash --login

#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --account=pawsey0159
#SBATCH --export=none

module swap PrgEnv-cray PrgEnv-gnu
module load blast+

echo "Start aprun `date`"

# Use MY_BLAST and MY_BLAST_ARGS to set the blast task and the blast 
# command line options, respectively.
#
# The command line does not need to specify the following (these
# are handled in my-blast.sh via environment variables):
#
#  1. The database is specified via a (full) path MY_BLAST_DB
#  2. The number of threads is specified via MY_BLAST_THREADS
#  3. One or more input query files (.fasta) should be specified after
#     ./my-blast.sh
#
#  aprun -n 1 -d 48 -j 2 ./my-blast.sh file1.fasta [file2.fasta [...]]
#
# This script should always use 48 threads with 2 threads per core "-j 2"
#
# For each input ".fasta" file, a corresponding ".blast" file will be
# produced to hold the output.

export MY_BLAST="blastn -task blastn"
export MY_BLAST_ARGS="-num_alignments 10 -num_descriptions 10 -reward 1"
export MY_BLAST_DB=/group/pawsey0159/blast/db/nt
export MY_BLAST_THREADS=48

aprun -n 1 -d ${MY_BLAST_THREADS} -j 2 ./my-blast.sh U*fa

echo "Finish aprun `date`"
