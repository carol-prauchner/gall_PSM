
rm(list=ls())
library(ape)
library(geiger)
library(nlme)
library(phytools)
library(tidyverse)
library(diversitree)


setwd("/Users/carol/Documents/gall_PSM_paper")
pmg<-utils::read.csv("data_PSM_gall.csv",sep=",", header=T)
#nomes_filtrados <- pmg$Families_of_seed_plant[pmg$presence_neotropical == 0]

texto1<-textreadr::read_doc("/Users/carol/Documents/gall_PSM_paper/jse12086-sm-0003-suppapp-s3.doc")
arvore<-read.tree(text=texto1)
neotr_families<-utils::read.csv("families_neotropical_reviwed.csv",sep=",", header=T)
neotr_families1<-neotr_families$Familias
tree_fam<-sort(arvore$tip.label)
remove_fam<-which(tree_fam %in% neotr_families1 ==F)
remove_fam1<-tree_fam[remove_fam]
arvore1<-drop.tip(arvore,tip=remove_fam1) #retirar familias da arvore que nao ocorrem no neotropico

#retirar dos dados as familias que nao ocorrem no neotropico
rownames(pmg)<-pmg$Families_of_seed_plant
pmg2 <- pmg[!(rownames(pmg) %in% remove_fam1), ]
name.check(arvore1,pmg2)
# Removing node labels:
arvore1$node.label<-NULL

pmg2<-pmg2[,1:5]
str(pmg2)
######################################### getting gall info
setwd("/Users/carol/Desktop")

library(dplyr)
library(tidyr)
library(stringr)

#importar e formatar dados
database_data<-read.csv("BD_final_R.csv", sep=",", header=T)

database_data[,22]
database_data[, 4:22] <- as.data.frame(apply(database_data[, 4:22], 2, tolower))

for(i in 4:22){
  database_data[,i] <- ifelse(database_data[,i] == "", "NI", database_data[,i])
}

unique(database_data$inducer_order)


#All galls
families_galls <- database_data %>%
  distinct(plant_family) %>%
  mutate(plant_family = str_to_title(plant_family)) %>%
  pull(plant_family)
families_galls



#Diptera
fam_dip <- database_data %>%
  filter(inducer_order == "diptera") %>%
  distinct(plant_family) %>%
  mutate(plant_family = str_to_title(plant_family)) %>%
  pull(plant_family)
fam_dip

#Hemiptera
fam_hem <- database_data %>%
  filter(inducer_order == "hemiptera") %>%
  distinct(plant_family) %>%
  mutate(plant_family = str_to_title(plant_family)) %>%
  pull(plant_family)
fam_hem
#Hymenoptera
fam_hym <- database_data %>%
  filter(inducer_order == "hymenoptera") %>%
  distinct(plant_family) %>%
  mutate(plant_family = str_to_title(plant_family)) %>%
  pull(plant_family)
fam_hym
#coleoptera
fam_col <- database_data %>%
  filter(inducer_order == "coleoptera") %>%
  distinct(plant_family) %>%
  mutate(plant_family = str_to_title(plant_family)) %>%
  pull(plant_family)
fam_col
#Lepidoptera
fam_lep <- database_data %>%
  filter(inducer_order == "lepidoptera") %>%
  distinct(plant_family) %>%
  mutate(plant_family = str_to_title(plant_family)) %>%
  pull(plant_family)
fam_lep


############################## joining tables
new_gall_psm<-pmg2
str(new_gall_psm)
new_gall_psm$Families_of_seed_plant

new_gall_psm <- new_gall_psm %>%
  mutate(
    Gall = as.integer(Families_of_seed_plant %in% families_galls),
    Diptera = as.integer(Families_of_seed_plant %in% fam_dip),
    Hemiptera = as.integer(Families_of_seed_plant %in% fam_hem),
    Hymenoptera = as.integer(Families_of_seed_plant %in% fam_hym),
    Coleoptera = as.integer(Families_of_seed_plant %in% fam_col),
    Lepidoptera = as.integer(Families_of_seed_plant %in% fam_lep)
  )

soma_ordens <- colSums(new_gall_psm[, c("Gall","Diptera", "Hemiptera", "Hymenoptera", "Coleoptera", "Lepidoptera")], na.rm = TRUE)

str(new_gall_psm)

sum(new_gall_psm$Gall)
str(pmg2)




new_gall_psm<-new_gall_psm[2:11]
setwd("/Users/carol/Documents/gall_PSM_paper")
#write.csv(new_gall_psm,file="gall_psm_final.csv")
database_data<-read.csv("gall_psm_final.csv", sep=",", header=T)
str(database_data)
