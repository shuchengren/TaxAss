#!/bin/bash

# This is a sourceable bash script that runs steps 15-15.5 of the workflow.  
# NOTE that the pident chosen here is the final taxonomy one, you may want to change it.
# RRR 2/11/16

# Choose final pident.

pident=("98")
fwbootstrap=("80")
ggbootstrap=("80")
processors=("2")

# 15
Rscript find_classification_disagreements.R otus.$pident.taxonomy otus.general.taxonomy ids.above.$pident conflicts_$pident $pident $fwbootstrap $ggbootstrap final &&
# 15.5.a
Rscript plot_classification_improvement.R final.taxonomy.pvalues final.general.pvalues total.reads.per.seqID.csv plots final.taxonomy.names final.general.names &&
# 15.5.b
mothur "#classify.seqs(fasta=otus.fasta, template=custom.fasta, taxonomy=custom.taxonomy, method=wang, probs=T, processors=$processors, cutoff=0)" &&
cat otus.custom.wang.taxonomy > otus.custom.taxonomy &&
sed 's/[[:blank:]]/\;/' <otus.custom.taxonomy >otus.custom.taxonomy.reformatted &&
mv otus.custom.taxonomy.reformatted otus.custom.taxonomy &&
mkdir conflicts_forcing
Rscript find_classification_disagreements.R otus.custom.taxonomy otus.$pident.$fwbootstrap.$ggbootstrap.taxonomy ids.above.$pident conflicts_forcing NA $fwbootstrap $ggbootstrap forcing &&
Rscript plot_classification_disagreements.R otus.abund plots conflicts_forcing otus.custom.$fwbootstrap.taxonomy otus.$pident.$fwbootstrap.$ggbootstrap.taxonomy &&

printf 'Steps 15, 15.5.a., and 15.5.b. have finished running.  When you are finished with all your analysis you can tidy up your working directory with step 16. \n \a'
sleep .1; printf '\a'; sleep .1; printf '\a'; sleep .1; printf '\a'; sleep .1; printf '\a'; sleep .1; printf '\a'

exit 0