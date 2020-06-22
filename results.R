#Packages installation and libraries loading

#install.packages("readxl") #install package to read ".xlsx" files
#install.packages("ggplot2") #install ggplot2 package
#install.packages("ggpubr") #install ggpubr package
#install.packages("ggbiplot") #install ggbiplot package
#install.packages("ggfortify") #install ggfortify package

library("readxl") #load the library
library("ggplot2") #load the library
library("ggbiplot") #load the library
library("ggpubr") #load the library
library("ggfortify") #load the library

##Load the data

setwd("~/Desktop/Internship_TFG/Analysis") #Set working directory

matriu <- read_excel("Matriu2.xlsx") #read the data 
View(matriu)

##Prepare the matrix to be analyzed

matriu <- matriu[-c(1), ] #delete first row

#put the first row as header
names(matriu) <- as.matrix(matriu[1, ]) 
matriu <- matriu[-1, ]
matriu[] <- lapply(matriu, function(x) type.convert(as.character(x)))
View(matriu) #View the matrix
dim(matriu) #number of rows and columns in the matrix

#Participants demographics:

#Patients: 

patients <- which(matriu[,2]==1) #rows of the patients
presympt <- which(matriu[,3]==2) #rows of the presymtomatics
sympt <- which(matriu[,3]==1) #rows of the symptomatics
mean_age_patients <- mean(matriu$age[patients], na.rm=T) #mean age patients
mean_age_presympt <- mean(matriu$age[presympt], na.rm = T) #mean age presymptomatics
mean_age_sympt <- mean(matriu$age[sympt], na.rm = T) #mean age symptomatics



####PCA: 

matrix.PCA <- matriu[, c(1,3,194,197,206,209,236,239)] #subset of the matrix containing the interesting variables
View(matrix.PCA)

table(matrix.PCA[2]) #number of subjects per group
dim(matrix.PCA) #check dimension of the matrix

matrix.PCA <- matrix.PCA[,c(2,3:8)] #take only FA values and the group they belong to
View(matrix.PCA)

pca_FA <- prcomp(matrix.PCA[2:7], scale = T) #compute PCA
summary(pca_FA) #view summary of the PCA 
screeplot(pca_FA) #we will consider the ones above 20% of proportion of variance

PC1 <- pca_FA$x[,1] #PC1 component
PC2 <- pca_FA$x[,2] #PC2 component

p<-ggplot(pca_FA,aes(x=PC1,y=PC2)) #plot PC1 and PC2
p<-p+geom_point()
p

plot(pca_FA$rotation[,1], col=rep(1:3, each=2), xlab="Tract", ylab="Principal Component 1")
legend(x="topleft",legend=c("Accumbens - motivational", "Caudate - executive", "Putamen -motor"),
       col=c("black", "red", "green"), pch=1, cex=0.8)#plot PC1 coloring by tract
#plot of PC1: all values are negative, which means that all tracts are degenerating

plot(pca_FA$rotation[,2], col=rep(1:3, each=2), xlab="Tract", ylab="Principal Component 2")
legend(x="bottomleft",legend=c("Accumbens - motivational", "Caudate - executive", "Putamen -motor"),
       col=c("black", "red", "green"), pch=1, cex=0.8)#plot PC1 coloring by tract#plot PC2 coloring by tract
#here we can see that each of the tracts has a different weight in the PC2
#in this case, we obtain positive values of the accumbens-motivational, negative values for the caudate-executive and values around 0 of the putamen-motor tract.
#we might consider it is a compensation of values

biplot(pca_FA) #we can see that PC1 is negative, whereas PC2 has a compensation between accumbens-motivational and caudate-executive

autoplot(pca_FA, label = T, shape=F, colour = matriu$Group_split + 1, loadings = TRUE, loadings.label = TRUE, loadings.label.size = 3) #represent sujects in the PC components colored by group (black = Controls, red = symptom, green = presymptom)



#principal components: create a column in the matrix with high PC1 and high PC2 as 0 and low PC1 and low PC2 as 1

PC1 <- pca_FA$x[,1] #PC1 component
matriu["PC1_PCA"] <- PC1 #create a column with PC1 values
PC1 <- replace(PC1, PC1>0, 0) #high values
PC1 <- replace(PC1, PC1<0, 1) #low values
matriu["PC1_PCA_group"] <- PC1 #PC1 in two groups


PC2 <- pca_FA$x[,2] #PC2 component
matriu["PC2_PCA"] <- PC2 #create a column with PC1 values
PC2 <- replace(PC2, PC2>0, 0) #high values
PC2 <- replace(PC2, PC2<0, 1) #low values
matriu["PC2_PCA_group"] <- PC2 #PC2 in two groups
View(matriu)


cor.test(matrix.PCA[[2]], pca_FA$x[,1])

boxplot(as.factor(matrix.PCA[[2]]), pca_FA$x[,1])

boxplot(matriu[[2]], pca_FA$x[,2])



## K-means analysis 

set.seed(231)
?scale()
dim(matrix.PCA)
matrix.PCA[,2:7] <- as.matrix(scale(matrix.PCA[,2:7])) #scale the values
View(matrix.PCA)
kmeans_FA <- kmeans(matrix.PCA[,2:7], 2) #compute the k means for two centroids
names(kmeans_FA)
clusters <-kmeans_FA$cluster #look for the assignation of clusters of each subject

matrix.PCA["PC1_PCA_group"] <- PC1 #add column with PC1 group for high - low in the matrix
matrix.PCA["PC2_PCA_group"] <- PC2 #add column with PC2 group for high - low in the matrix

autoplot(kmeans(matrix.PCA[2:7], 2), data = matrix.PCA) #plot of the clusters
autoplot(kmeans(matrix.PCA[2:7], 2), data = matrix.PCA, colour=matrix.PCA$Group_split+1) #plot of the clusters colored by group (controls, symtomatics, presymtomatics)
autoplot(kmeans(matrix.PCA[3:8], 2), data = matrix.PCA, colour=matrix.PCA$PC1_PCA_group+1) #plot of the clusters colored by high/low PC1 obtained by the PCA
autoplot(kmeans(matrix.PCA[3:8], 2), data = matrix.PCA, colour=matrix.PCA$PC2_PCA_group+1)#plot of the clusters colored by high/low PC2 obtained by the PCA


length(kmeans_FA$cluster)

matriu_kmeans <- matriu[,c(1,29,92,108,109,87,60,86,174,176,404,405,406,407)] #matrix containing only the clinical variables and PC1, PC2 and groups of PC1 and PC2
matriu_kmeans["kmeans"] <- clusters

View(matriu_kmeans)



##CORRELATIONS between clinical variables :

#matrix of interest:

matrix_kmeans <- matriu_kmeans[c(31:67),c(1:4,6,7,9:14)] #matrix that contains the clinical variables of our interest and only the patients
View(matrix_kmeans) #view the matrix
dim(matrix_kmeans) #dimension of the matrix --> 37 rows (subjects), 13 columns (variables)

matrix_kmeans[, c(2:5,9,11)] <- scale(matrix_kmeans[, c(2:5,9,11)], scale = T, center = T) #scale variables without 0's
View(matrix_kmeans)


which(matrix_kmeans[,9]>1.5) #rows with PC1 higher than 1.5 will be considered outliers
which(matrix_kmeans[,9]< -1.5) #rows with PC1 smaller than -1.5 will be considered outliers

which(matrix_kmeans[,11]>1.5) #rows with PC2 higher than 1.5 will be considered outliers
which(matrix_kmeans[,11]< -1.5) #rows with PC2 smaller than -1.5 will be considered outliers

matrix_kmeans <- matrix_kmeans[-c(11,28,33,19,28,36,32,34,35),] #remove the outliers
View(matrix_kmeans)


#correlation between stroop interference and PC1/PC2

which(is.na(matrix_kmeans[[3]])) #we need to omit the NA values

which(matrix_kmeans[,3]>1.5) #rows with stroop interference higher than 1.5 will be considered outliers
which(matrix_kmeans[,3]< -1.5) #rows with stroop interference smaller than -1.5 will be considered outliers

matrix_kmeans_stroopinterfernce <- matrix_kmeans[-c(4, 9,17,23,25,26),] #remove NA and outliers


cor.test(matrix_kmeans_stroopinterfernce[[3]], matrix_kmeans_stroopinterfernce$PC1_PCA) #correlation between stroop interference and PC1
cor.test(matrix_kmeans_stroopinterfernce[[3]], matrix_kmeans_stroopinterfernce$PC2_PCA) #correlation between stroop interference and PC2
plot(matrix_kmeans_stroopinterfernce$PC1_PCA, matrix_kmeans_stroopinterfernce[[3]]) #plot of the PC1 with stroop interference
plot(matrix_kmeans_stroopinterfernce$PC2_PCA, matrix_kmeans_stroopinterfernce[[3]]) #plot of the PC2 with stroop interference

ggscatter(matrix_kmeans_stroopinterfernce, x = "PC1_PCA", y = "stroop_intereference", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "PC1", ylab = "Stroop interference", col = "darkgreen")

ggscatter(matrix_kmeans_stroopinterfernce, x = "PC2_PCA", y = "stroop_intereference", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "PC2", ylab = "Stroop interference")


#correlation between TMT_diff_B_A_seconds_ corrected and PC1/PC2

which(is.na(matrix_kmeans[[4]])) #we need to omit the NA values

matrix_kmeans[which(matrix_kmeans[,4]>1.5),] #rows with TMT_diff_B_A_seconds_ corrected higher than 1.5 will be considered outliers
matrix_kmeans[which(matrix_kmeans[,4]< -1.5),] #rows with TMT_diff_B_A_seconds_ corrected smaller than -1.5 will be considered outliers

matrix_kmeans_TMT<- matrix_kmeans[-c(28,29),] #remove NA and outliers


cor.test(matrix_kmeans_TMT[[4]], matrix_kmeans_TMT$PC1_PCA) #correlation TMT_diff_B_A_seconds_ corrected and PC1
cor.test(matrix_kmeans_TMT[[4]], matrix_kmeans_TMT$PC2_PCA) #correlation between TMT_diff_B_A_seconds_ corrected and PC2
plot(matrix_kmeans_TMT$PC1_PCA, matrix_kmeans_TMT[[4]]) #plot of the PC1 with TMT_diff_B_A_seconds_corrected
plot(matrix_kmeans_TMT$PC2_PCA, matrix_kmeans_TMT[[4]]) #plot of the PC2 with TMT_diff_B_A_seconds_corrected


ggscatter(matrix_kmeans_TMT, x = "PC1_PCA", y = "TMT_diff_B_A_seconds_corrected", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "PC1", ylab = "TMT_diff_B_A_seconds_corrected", col = "darkgreen")

ggscatter(matrix_kmeans_TMT, x = "PC2_PCA", y = "TMT_diff_B_A_seconds_corrected", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "PC2", ylab = "TMT_diff_B_A_seconds_corrected")


#correlation between digital symbols and PC1/PC2 --> no dóna

which(is.na(matrix_kmeans[[5]])) #we need to omit the NA values

which(matrix_kmeans[,5]>1.5) #rows with digital symbols higher than 1.5 will be considered outliers
which(matrix_kmeans[,5]< -1.5)#rows with digital symbols smaller than -1.5 will be considered outliers

matrix_kmeans_digitalsymbols<- matrix_kmeans[-c(11,17,22),] #remove NA and outliers
View(matrix_kmeans_digitalsymbols)

cor.test(matrix_kmeans_digitalsymbols[[5]], matrix_kmeans_digitalsymbols$PC1_PCA) #correlation between digital symbols and PC1
cor.test(matrix_kmeans_digitalsymbols[[5]], matrix_kmeans_digitalsymbols$PC2_PCA) #correlation between digital symbols and PC2
plot(matrix_kmeans_digitalsymbols$PC1_PCA, matrix_kmeans_digitalsymbols[[5]]) #plot of the PC1 with digital symbols
plot(matrix_kmeans_digitalsymbols$PC2_PCA, matrix_kmeans_digitalsymbols[[5]]) #plot of the PC2 with digital symbols


#correlation between UHDRSmotor and PC1/PC2

View(matrix_kmeans)
which(is.na(matrix_kmeans[[6]])) #we need to omit the NA values

which(matrix_kmeans[,6]==0) #as we have lots of 0 values, we will remove them

matrix_kmeans_motor <- matrix_kmeans[-c(17,19,20,22,24,25,29),] #remove rows with value 0
dim(matrix_kmeans_motor) #check dimensions of the matrix

matrix_kmeans_motor[,6] <- scale(matrix_kmeans_motor[,6], center= T, scale = T) #scale the UHDRSmotor values
View(matrix_kmeans_motor)

which(matrix_kmeans_motor[,6]>1.5) #rows with uhdrsmotor higher than 1.5 will be considered outliers
which(matrix_kmeans_motor[,6]< -1.5) #rows with uhdrsmotor smaller than -1.5 will be considered outliers

matrix_kmeans_motor<- matrix_kmeans_motor[-c(11,16,21),] #remove NA and outliers
View(matrix_kmeans_motor)

cor.test(matrix_kmeans_motor[[6]], matrix_kmeans_motor$PC1_PCA) #correlation between UHDRSmotor and PC1
cor.test(matrix_kmeans_motor[[6]], matrix_kmeans_motor$PC2_PCA) #correlation between UHDRSmotor and PC2
plot(matrix_kmeans_motor$PC1_PCA, matrix_kmeans_motor[[6]]) #plot of the PC1 with UHDRSmotor
plot(matrix_kmeans_motor$PC2_PCA, matrix_kmeans_motor[[6]]) #plot of the PC2 with UHDRSmotor




#correlation between depression and PC1/PC2

which(is.na(matrix_kmeans[[7]])) #we need to omit the NA values

which(matrix_kmeans[,7]==0) #as we have lots of 0 values, we will remove them


matrix_kmeans_depression <- matrix_kmeans[-c(3,4,5,6,7,10,11,14,15,16,17,19,20,21,22,24,25,28,29),]  #remove rows with value 0
dim(matrix_kmeans_depression) #check dimensions of the matrix
View(matrix_kmeans_depression)
matrix_kmeans_depression[,7] <- scale(matrix_kmeans_depression[,7], center= T, scale = T) #scale the depression values
View(matrix_kmeans_depression)

which(matrix_kmeans_depression[,7]>1.5) #rows with depression higher than 1.5 will be considered outliers
which(matrix_kmeans_depression[,7]< -1.5) #rows with depression smaller than -1.5 will be considered outliers

matrix_kmeans_depression<- matrix_kmeans_depression[-c(6),] #remove NA and outliers
View(matrix_kmeans_depression)

cor.test(matrix_kmeans_depression[[7]], matrix_kmeans_depression$PC1_PCA) #correlation between depression and PC1
cor.test(matrix_kmeans_depression[[7]], matrix_kmeans_depression$PC2_PCA) #correlation between depression and PC2
plot(matrix_kmeans_depression$PC1_PCA, matrix_kmeans_depression[[7]]) #plot of the PC1 with depression
plot(matrix_kmeans_depression$PC2_PCA, matrix_kmeans_depression[[7]]) #plot of the PC2 with depression

ggscatter(matrix_kmeans_depression, x = "PC1_PCA", y = "Depression_score", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "PC1", ylab = "Depression score")


ggscatter(matrix_kmeans_depression, x = "PC2_PCA", y = "Depression_score", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "PC2", ylab = "Depression score")




#relationship between components and presymtomatics/symptomatics


matrix_patients <- matriu[, c(3,404:407)] #matrix includint the group split and PC1, PC2 values

View(matrix_patients)

which(is.na(matrix_patients[[1]])) #NA values 

NA_values_patients <- matrix_patients[,c(2,4)] <- scale(matrix_patients[,c(2,4)], center= T, scale = T) #scale the PC1 and PC2 values

which(matrix_patients[,c(2)]>1.5) #rows with PC1 and PC2 higher than 1.5 will be considered outliers
which(matrix_patients[,c(2)]< -1.5) #rows with PC1 and PC2 smaller than -1.5 will be considered outliers

matrix_patients <- matrix_patients[-c(40,41,42, 50,58,60, 7, 49,63),] #remove ouliers
matrix_patients <- matrix_patients[31:58,] #remove controls

ggplot(matrix_patients, aes(x=as.factor(matrix_patients[[1]]), y=matrix_patients[[2]], fill=as.factor(matrix_patients[[1]]))) + 
  geom_boxplot(na.rm=T) + labs(x = "Group", y ="PC1", title = "Principal Component 1 per patients group" )+ 
  scale_fill_discrete(name = "Group", labels = c("Symptomatics", "Presymptomatics")) #boxplot of PC1 depending on premanifes/manifest stage


ggplot(matrix_patients, aes(x=as.factor(matrix_patients[[1]]), y=matrix_patients[[4]], fill=as.factor(matrix_patients[[1]]))) + 
  geom_boxplot(na.rm=T) + labs(x = "Group", y ="PC2", title = "Principal Component 2 per patients group" )+ 
  scale_fill_discrete(name = "Group", labels = c("Symptomatics", "Presymptomatics")) #boxplot of PC2 depending on premanifes/manifest stage

values_symptomatics <- matrix_patients$PC1_PCA[matrix_patients$Group_split==1] #values of PC1 in symtomatics
values_presymptomatics <- matrix_patients$PC1_PCA[matrix_patients$Group_split==2]#values of PC1 in presymtomatics

t.test(values_presymptomatics, values_symptomatics) #t-test between values of PC1 of presymtomatics/symptomatics --> no significantly differences detected

values_symptomatics <- matrix_patients$PC2_PCA[matrix_patients$Group_split==1] #values of PC2 in symtomatics
values_presymptomatics <- matrix_patients$PC2_PCA[matrix_patients$Group_split==2]#values of PC2 in presymtomatics

t.test(values_presymptomatics, values_symptomatics) #t-test between values of PC1 of presymtomatics/symptomatics --> no significantly differences detected


