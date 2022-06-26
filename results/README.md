## Results
This directory houses three results files created by the [RMarkdown workflow](https://github.com/naturalis/trait-functional-poaceae/blob/main/scripts/seedmass_wf.Rmd).
The first figure `boxplots-1.pdf` is a set of box plots representing the
spread of the log seed mass in three subsets of the Poaceae data.
The first subset is of 13 Domesticated species found in the data.
The second subset is of 10 wild ancestors, aka crop progenitors, of the domesticated species.
The final subset is of all species not in the first sets, thus all other wild species.
<br>
<br>
Next are two phylogenetic trees. The `treefigure-1.pdf` tree has a dendogram
showing the evolutionary relation of the species. Then at the tips of the tree,
there is a one-dimensional heatmap showing the log seed mass. Next to that is
the absolute value of the seed mass. Next to that is the species name.
<br>
In `treefigure-2.pdf` the same tree is visible, except now the Y-axis indicates
the log seed mass. By taking the average of the seed mass of two tips the seed mass
it estimates the seed mass of their closest common ancestor. This is how the Y position
of the internal nodes are calculated. The X-axis position is just the same as the previous tree.

## PCA Results
Six png's were added displaying information about the results from the PCA.
<br>
`PCA_biplot.png` shows a bi-plot with the placement of species on dimension 1 and 2, aswell as the direction and conritbution of variables for dimension 1 and 2.
`PCA_AllDimContrib.png` shows the total variation contribution of the top ten dimensions.
`PCA_Dim3contrib.png` and `PCA_Dim6Contrib.png` shows the total contribution of the top ten variables for Dimension 3 and 6.
`PCA_scatterAspect.png` and `PCA_scatterPETWQ.png` shows a scatterplot of the relation between Aspect/PETWettestQuarter and seed mass.
