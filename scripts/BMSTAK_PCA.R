"
Script for PCA and stepwise phylogenetic analysis on Poaceae seed mass and
environmental data.
Made by Laurens-Willem Janssen, for Naturalis.
Guided by Rutger Vos

"


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

#Filtering the species to the ones present in raw_means, poaceae_seedmasses and phy datafiles.
rmp <- raw_means[which(raw_means$X %in% poaceae_seedmasses$organism),]
newphy <- keep.tip(phy, gsub(" ", "_", rmp$X))
newphy <- drop.tip(newphy, c("Aegilops_crassa", "Aegilops_cylindrica", "Aegilops_speltoides", "Aegilops_tauschii",
                           "Alopecurus_pratensis", "Alopecurus_vaginatus", "Avena_barbata", "Briza_maxima",
                           "Calamagrostis_arundinacea", "Calamagrostis_canadensis", "Chionochloa_rigida",
                           "Digitaria_violascens", "Echinochloa_crus-galli", "Eleusine_indica", "Eragrostis_pilosa",
                           "Lagurus_ovatus", "Lolium_perenne", "Lophatherum_gracile", "Melica_ciliata",
                           "Oryza_rufipogon", "Poa_colensoi", "Sporobolus_africanus", "Sporobolus_anglicus",
                           "Trisetum_flavescens", "Triticum_dicoccoides", "Uniola_paniculata", "Zea_mays"))
rmp <- rmp[-c(1:7, 11, 13, 16, 22, 25, 27, 32, 35, 43, 48, 53, 58:60, 64, 65, 69, 71, 74, 75), ]

#Normalisation.
rmp_norm <- as.data.frame(scale(rmp[,-1]))
rownames(rmp_norm) <- rmp[,1]

#PCA, and creating a data.frame for merging with poaceae_seedmasses.
rmp_PCA <- prcomp(rmp_norm, scale = FALSE)
resind <- get_pca_ind(rmp_PCA)
rescoord <- as.data.frame(resind$coord)
rescoord['organism'] <- rmp$X

#Merging the PCA results with the seed masses.
poa_two <- poaceae_seedmasses[ , c('organism', 'measurement')]
newresind <- merge(poa_two, rescoord, by.x = c('organism'), by.y = c('organism'))
newresind <- newresind[!duplicated(newresind[c('organism')]), ]
rownames(newresind) <- gsub(" ", "_",newresind$organism)
newresind <- subset(newresind, select = -c(organism))
newresind$measurement <- log(newresind$measurement)

#Performing phylogenetic analysis.
phylomodel <- phylostep(measurement ~ Dim.1 + Dim.2 + Dim.3 + Dim.4 + Dim.5 + Dim.6, data = newresind, phy = newphy, model = "BM", direction = "both")
phyloend <- phylolm("measurement ~ 1 + Dim.3 + Dim.6", newresind, phy = newphy, model = "BM")
summary(phyloend)

fviz_pca_biplot(rmp_PCA)
fviz_contrib(rmp_PCA, choice = "var", axes = 3, top = 10)
fviz_contrib(rmp_PCA, choice = "var", axes = 6, top = 10)
fviz_eig(rmp_PCA)
eigenvalues <- get_eig(rmp_PCA)

rmp_vis <- merge(poa_two, rmp, by.x = c('organism'), by.y = c('X'))
rmp_vis <- rmp_vis[!duplicated(rmp_vis[c('organism')]), ]
plot.default(rmp_vis$measurement, rmp_vis$PETWettestQuarter,
             xlab = "Seed Size measurement (mg)", ylab = "PETWettestQuarter", main = "PETWettestQuarter compared to seed mass")
rmp_vis$measurement <- log(rmp_vis$measurement)
plot.default(rmp_vis$measurement, rmp_vis$Aspect,
             xlab = "Seed Size measurement (mg)", ylab = "Aspect", main = "Aspect compared to seed mass")
plot.default(rmp_vis$measurement, rmp_vis$bio8)
