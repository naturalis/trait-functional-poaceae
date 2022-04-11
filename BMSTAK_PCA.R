#Gebruikte packages installeren.
install.packages("ggplot2")
install.packages("factoextra")

#Gebruikte packages inladen.
library(ggplot2)
library(factoextra)

#Bestanden inlezen.
raw_means <- read.csv("raw_means.csv", stringsAsFactors = FALSE)
poaceae_seedmasses <- read.csv("poaceae_seedmasses.csv", stringsAsFactors = FALSE)

#APE
install.packages("ape")
library(ape)
phylist <- poaceae_seedmasses$organism
phylist <- gsub(" ", "_", phylist)
phylist <- intersect(phylist, phy$tip.label)
phy <- read.tree("ALLMB.tre.txt")
newphy <- keep.tip(phy, phylist)

#Niet-poaceae uit raw_means filteren.
phylistspace <- gsub("_", " ", phylist)
raw_means_poaceae <- raw_means[which(raw_means$X %in% phylistspace),]
newpoa <- poaceae_seedmasses[which(poaceae_seedmasses$organism %in% raw_means_poaceae$X),]

#Normalisatie.
rmp_norm <- as.data.frame(scale(raw_means_poaceae[,-1]))
rownames(rmp_norm) <- raw_means_poaceae[,1]

#Uitvoeren PCA.
rmp_PCA <- prcomp(rmp_norm, scale = FALSE)

#Grafiek en resind genereren.
fviz_pca_var(rmp_PCA)
fviz_pca_biplot(rmp_PCA)
eigen <- get_eigenvalue(rmp_PCA)
resvar <- get_pca_var(rmp_PCA)
resind <- get_pca_ind(rmp_PCA)

raw_means_poaceae$X <- gsub(" ", "_", raw_means_poaceae$X)
np_two <- newpoa[ , c('organism', 'measurement')]
np_two$organism <- gsub(" ", "_", np_two$organism)
rescoord <- resind$coord
rescoord <- cbind(rescoord, new_col = raw_means_poaceae$X)
newresind <- merge(np_two, rescoord, by.x = c('organism'), by.y = c('new_col'))

install.packages("phylolm")
library(phylolm)
phylostep("measurement ~ Dim.1 + Dim.2 + Dim.3 + Dim.4 + Dim.5 + Dim.6 + Dim.7", data = newresind, phy = newphy, model = "BM", direction = "both")
hylolm()