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

#Keeping poaceae species in the tree.
rmp <- raw_means[which(raw_means$X %in% poaceae_seedmasses$organism),]
newphy <- keep.tip(phy, gsub(" ", "_", rmp$X))

#Normalisation.
rmp_norm <- as.data.frame(scale(rmp[,-1]))
rownames(rmp_norm) <- rmp[,1]

#PCA and making a data.frame with the PCA results.
rmp_PCA <- prcomp(rmp_norm, scale = FALSE)
resind <- get_pca_ind(rmp_PCA)
rescoord <- as.data.frame(resind$coord)
rescoord['organism'] <- rmp$X

#Preparing newresind data.frame for phylostep.
poa_two <- poaceae_seedmasses[ , c('organism', 'measurement')]
newresind <- merge(poa_two, rescoord, by.x = c('organism'), by.y = c('organism'))
newresind <- newresind[!duplicated(newresind[c('organism')]), ]
rownames(newresind) <- gsub(" ", "_",newresind$organism)
newresind <- subset(newresind, select = -c(organism))

redresind <- newresind[-c(1:4, 10, 11, 15, 19, 22, 23, 28, 34, 36, 37, 40, 48, 50, 50:52, 54, 60, 67, 68, 72:75), ]
redresind$measurement <- log(redresind$measurement)

cphy <- drop.tip(newphy, c("Aegilops_crassa", "Aegilops_cylindrica", "Aegilops_speltoides", "Aegilops_tauschii",
                        "Alopecurus_pratensis", "Alopecurus_vaginatus", "Avena_barbata", "Briza_maxima",
                        "Calamagrostis_arundinacea", "Calamagrostis_canadensis", "Chionochloa_rigida",
                        "Digitaria_violascens", "Echinochloa_crus-galli", "Eleusine_indica", "Eragrostis_pilosa",
                        "Lagurus_ovatus", "Lolium_perenne", "Lophatherum_gracile", "Melica_ciliata",
                        "Oryza_rufipogon", "Poa_colensoi", "Sporobolus_africanus", "Sporobolus_anglicus",
                        "Trisetum_flavescens", "Triticum_dicoccoides", "Uniola_paniculata", "Zea_mays"))

#Performing phylogenetic analysis.
phylomodel <- phylostep(measurement ~ Dim.1 + Dim.2 + Dim.3 + Dim.4 + Dim.5 + Dim.6 + Dim.7, data = redresind, phy = cphy, model = "BM", direction = "both")
phyloend <- phylolm("measurement ~ 1 + Dim.3 + Dim.5", redresind, phy = cphy, model = "BM")
summary(phyloend)

#Dimension 3 contribution.
fviz_contrib(rmp_PCA, choice = "var", axes = 3, top = 10)
#Dimension 1 and 3 biplot.
fviz_pca_var(rmp_PCA, axes = c(1, 3))
#Dimension eigen-values.
fviz_eig(rmp_PCA)
