#Gebruikte packages installeren.
install.packages("ggplot2")
install.packages("factoextra")

#Gebruikte packages inladen.
library(ggplot2)
library(factoextra)

#Bestanden inlezen.
raw_means <- read.csv("raw_means.csv", stringsAsFactors = FALSE)
poaceae_seedmasses <- read.csv("poaceae_seedmasses.csv", stringsAsFactors = FALSE)

#Niet-poaceae uit raw_means filteren.
raw_means_poaceae <- raw_means[which(raw_means$X %in% poaceae_seedmasses$organism),]

#Normalisatie.
rmp_norm <- as.data.frame(scale(raw_means_poaceae[,-1]))

#Uitvoeren PCA.
rmp_PCA <- prcomp(rmp_norm, scale = FALSE)

#Grafiek en resind genereren.
fviz_pca_var(rmp_PCA)
fviz_pca_biplot(rmp_PCA)
resind <- get_pca_ind(rmp_PCA)

#APE
#install.pacakges("ape")
#library(ape)
#pyh <- read.tree("file")
#keep.tip