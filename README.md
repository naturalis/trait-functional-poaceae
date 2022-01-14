# How does ecology predict seed mass?
--------------------------------------------------------------
In this project we identify how abiotic variables predict seed
mass and wild grasses and crop progenitors of the Poaceae family.
To do so we've created a shell script to get the seed mass data, and constructed
a workflow to analyse the seed mass data along with environmental data and a
phylogenetic tree.

### `/data`
This directory houses all the data downloaded automatically, and used for the
analysis. These are seed mass data, an aggregation of trait data, environmental
variables, and a phylogenetic tree.

### `/results`
This directory contains a boxplot and two tree figures generated in the workflow.

### `/scripts`
This directory has the two shell scripts used to aggregate trait data, and to
download the seed dry mass data. It also contains the R Markdown analysis, both
in an R Markdown format as well as a generated PDF file.