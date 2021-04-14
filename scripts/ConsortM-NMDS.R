#!/usr/bin/env Rscript



args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("This script required three inputs; data file, grouping file and project name.", call.=FALSE)
} else if (length(args)==3) {



##################################################################################
######                          Load in libraries                           ######
##################################################################################

# Check if required packages are already installed, and install if missing
#install.packages('vegan', repos='http://cran.us.r-project.org')
#install.packages('ade4', repos='http://cran.us.r-project.org')
#install.packages('adoni', repos='http://cran.us.r-project.org')



library('vegan')
library('ade4')
library('ggplot2')
library('phangorn')
#library('adoni')


##################################################################################
######                 User input required here parameter                   ######
##################################################################################
getwd()
setwd(getwd())
print(paste0("Current working dir: ", getwd()))


maldi_data = args[1] # <-- Give the combined MALDI file here

maldi_groups = args[2] # <-- Give the grouping file here

plot_name = args[3] # <-- Change to the name you want for your plots



##################################################################################
######                         Automatic under here                         ######
##################################################################################

adonis.pair<-function(dist.mat,Factor,nper=1000,corr.method="fdr"){
  require(vegan)
  as.factor(Factor)
  comb.fact<-combn(levels(Factor),2)
  pv<-NULL
  R2<-NULL
  SS<-NULL
  MeanSqs<-NULL
  F.Model<-NULL
  for (i in 1:dim(comb.fact)[2]){
    model.temp<-adonis(as.dist(as.matrix(dist.mat)[Factor==comb.fact[1,i] | Factor==comb.fact[2,i],Factor==comb.fact[1,i] | Factor==comb.fact[2,i]])~Factor[Factor==comb.fact[1,i] | Factor==comb.fact[2,i]],permutations=nper)
    pv<-c(pv,model.temp$aov.tab[[6]][1])
    R2<-c(R2,model.temp$aov.tab$R2[1])
    SS<-c(SS,model.temp$aov.tab[[2]][1])
    MeanSqs<-c(MeanSqs,model.temp$aov.tab[[3]][1])
    F.Model<-c(F.Model,model.temp$aov.tab[[4]][1])
  }
  pv.corr<-p.adjust(pv,method=corr.method)
  data.frame(combination=paste(comb.fact[1,],comb.fact[2,],sep=" <-> "),SumsOfSqs=SS,MeanSqs=MeanSqs,F.Model=F.Model,R2=R2,P.value=pv,P.value.corrected=pv.corr)}

##################################################################################
######                         Reading in the data                          ######
##################################################################################


raw.data <- read.table (file = maldi_data , check.names = FALSE, header = TRUE, dec = ".", sep = ",", row.names = 1, comment.char = "")
data <- t(raw.data)
print(paste0("The MALDI file line number is; ", nrow(data)))
print(row.names(data))

Grouping <- read.table (file = maldi_groups, check.names = FALSE, header = TRUE, dec = ".", sep = "\t", row.names = 1, comment.char = "")
print(paste0("The grouping file line number is; ", nrow(Grouping)))
print(Grouping$Condition)

cols <- c('#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080', '#ffffff', '#000000','lightblue','darkblue','lightgreen','darkgreen','pink','red','lightsalmon','orange','magenta','mediumpurple3','yellow','brown','black')


##################################################################################
######          Create basic plots for user assurance of quality            ######
##################################################################################


outfile <- sprintf("%s-bray_summed1.pdf",plot_name)
pdf(outfile) 
mds <- cmdscale(vegdist(data, method='bray'))
plot(mds, type = 'n')
points(mds, col = cols[Grouping$Condition], pch=16)
points(mds, pch=1)
legend('bottomleft', col=cols, legend=levels(Grouping$Condition), pch = 16, cex = 0.7)

dev.off() 



outfile <- sprintf("%s-morisita_summed1.pdf",plot_name)
pdf(outfile) 
mds <- cmdscale(vegdist(data, method='morisita'))
plot(mds, type = 'n')
points(mds, col = cols[Grouping$Condition], pch=16)
points(mds, pch=1)
legend('bottomleft', col=cols, legend=levels(Grouping$Condition), pch = 16, cex = 0.7)
dev.off() 


outfile <- sprintf("%s-bray-text.pdf",plot_name)
pdf(outfile) 
loc <- cmdscale(vegdist(data, method='bray')) 
plot(mds, type="n", xlab="", ylab="")
#points(mds, pch=1)
#legend('bottomleft', col=cols, legend=levels(Grouping$Group), pch = 16, cex = 0.7)
text(mds, rownames(loc), cex=0.4) 
dev.off()


##################################################################################
######               Create Adonis plots for final user view                ######
##################################################################################

outfile <- sprintf("%s-bray-Adonis.pdf",plot_name)
d_Binary_matrix<- as.matrix(vegdist(data, method='bray'))
pdf(outfile) 
meta <- metaMDS(d_Binary_matrix,k = 2)
s.class(
  meta$points, col = unique(cols), cpoint = 2, fac = Grouping$Condition,
  sub = paste("metaNMDS plot stress is; ",formatC(meta[["stress"]], digits = 2)
, "",sep="")
)
dev.off()


##################################################################################
######                      Provide pairwise statistics                     ######
##################################################################################

stats = adonis.pair(as.dist(d_Binary_matrix), Grouping$Condition, nper = 1000, corr.method = "BH")

write.csv(stats, file = sprintf("%s-statistics.csv",plot_name))
}



##################################################################################
######                          Create dendogram                            ######
##################################################################################
color_easy = cols[Grouping$Condition]
dist_d_Binary_matrix <- as.dist(d_Binary_matrix)

all_fit <- hclust(dist_d_Binary_matrix, method = "ward.D2")

# Generates a tree from the hierarchically generated object
tree <- as.phylo(all_fit)

# Save the generated phylogram in a pdf file
outfile <- sprintf("%s-Dendrogram.pdf",plot_name)
pdf(outfile)

color_easy = cols[Grouping$Condition]
# The tree is visualized as a Phylogram color-coded by the selected group name
plot(tree, type = "phylogram",use.edge.length = TRUE, tip.color = (color_easy), label.offset = 0.01, cex=.5)
print.phylo(tree)
axisPhylo()
tiplabels(pch = 16, col = color_easy)
dev.off()
