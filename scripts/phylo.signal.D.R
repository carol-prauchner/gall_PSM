rm(list=ls())
library(ape)
library(geiger)
library(nlme)
library(phytools)
library(tidyverse)
library(caper)

setwd("/Users/carol/Documents/gall_PSM_paper")


database_data<-read.csv("gall_psm_final.csv", sep=",", header=T)

nomes_filtrados<-database_data$Families_of_seed_plant


texto1<-textreadr::read_doc("/Users/carol/Documents/gall_PSM_paper/jse12086-sm-0003-suppapp-s3.doc")
arvore<-read.tree(text=texto1)
arvore1<-keep.tip(arvore,tip=nomes_filtrados) #retirar familias da arvore que nao ocorrem no neotropico


##retirar dos dados as familias que nao ocorrem no neotropico
rownames(database_data)<-database_data$Families_of_seed_plant
#pmg2 <- pmg[!(rownames(pmg) %in% nomes_filtrados), ]
name.check(arvore1,database_data)

length(which(database_data$Gall ==1))

#######################################
#### sinal filogenetico (teste D)
# Removing node labels:
arvore1$node.label<-NULL

####
library(caper)
comp_dado <- comparative.data(phy = arvore1, data = database_data, names.col = Families_of_seed_plant, vcv = TRUE, na.omit = FALSE, warn.dropped = TRUE)


teste<-phylo.d(data=comp_dado,phy=arvore1,names.col = Families_of_seed_plant, 
               binvar = Gall,permut = 10000)
str(teste)
summary(teste)


####  D test for gall orders
#galls<-utils::read.csv("new_gall_psm.csv",sep=",", header=T)#open file with orders data
#gall_psm<-left_join(pmg2,galls, by="Families_of_seed_plant")#join with PSM data
#gall_psm[is.na(gall_psm)] <- 0 #change NA to zero




library(caper)
comp_dado_diptera <- comparative.data(phy = arvore1, data = database_data, names.col = Families_of_seed_plant, vcv = TRUE, na.omit = FALSE, warn.dropped = TRUE)

diptera<-phylo.d(data=comp_dado_diptera,phy=arvore1,names.col = Families_of_seed_plant, 
               binvar = Diptera,permut = 10000)
str(diptera)
summary(diptera)


hemiptera<-phylo.d(data=comp_dado_diptera,phy=arvore1,names.col = Families_of_seed_plant, 
                 binvar = Hemiptera,permut = 10000)

summary(hemiptera)


hymenoptera<-phylo.d(data=comp_dado_diptera,phy=arvore1,names.col = Families_of_seed_plant, 
                     binvar = Hymenoptera,permut = 10000)

summary(hymenoptera)

Coleoptera<-phylo.d(data=comp_dado_diptera,phy=arvore1,names.col = Families_of_seed_plant, 
                     binvar = Coleoptera,permut = 10000)

summary(Coleoptera)

Lepidoptera<-phylo.d(data=comp_dado_diptera,phy=arvore1,names.col = Families_of_seed_plant, 
                    binvar = Lepidoptera,permut = 10000)

summary(Lepidoptera)


