#Installing packages.
install.packages("ggplot2")
install.packages("factoextra")
install.packages("ape")
install.packages("phylolm")

#Library-ing packages.
library(ggplot2)
library(factoextra)
library(ape)
library(phylolm)

#Reading files.
raw_means <- read.csv("raw_means.csv", stringsAsFactors = FALSE)
poaceae_seedmasses <- read.csv("poaceae_seedmasses.csv", stringsAsFactors = FALSE)
phy <- read.tree("ALLMB.tre.txt")

rmp <- raw_means[which(raw_means$X %in% poaceae_seedmasses$organism),]
newphy <- keep.tip(phy, gsub(" ", "_", rmp$X))

#Normalisation.
rmp_norm <- as.data.frame(scale(rmp[,-1]))
rownames(rmp_norm) <- rmp[,1]

#PCA.
rmp_PCA <- prcomp(rmp_norm, scale = FALSE)
resind <- get_pca_ind(rmp_PCA)
rescoord <- as.data.frame(resind$coord)
rescoord['organism'] <- rmp$X

poa_two <- poaceae_seedmasses[ , c('organism', 'measurement')]
newresind <- merge(poa_two, rescoord, by.x = c('organism'), by.y = c('organism'))
newresind <- newresind[!duplicated(newresind[c('organism')]), ]
rownames(newresind) <- gsub(" ", "_",newresind$organism)
newresind <- subset(newresind, select = -c(organism))

'
cresind <- newresind[!duplicated(newresind[c("measurement")]), ]
cresind$measurement <- log(cresind$measurement)
cresind <- newresind[which(newresind$measurement < 1),]
cresind <- head.matrix(newresind)
cphy <- keep.tip(phy, c("Aegilops_crassa", "Aegilops_cylindrica", "Aegilops_speltoides", "Aegilops_tauschii", "Agrostis_gigantea", "Alopecurus_aequalis"))
'

#Phylostep & phylolm uitvoeren.
phylostep(measurement ~ Dim.1 + Dim.2 + Dim.3 + Dim.4 + Dim.5 + Dim.6 + Dim.7, data = newresind, phy = newphy, model = "BM", direction = "both")
phylolm()