rm(list=ls())

library(ape)
library(geiger)
library(nlme)
library(phytools)
library(textreadr)
library(dplyr)


setwd("/Users/carol/Documents/gall_PSM_paper")
database_data <- read.csv("gall_psm_final.csv", sep = ",", header = TRUE)

texto1<-read_doc("/Users/carol/Documents/gall_PSM_paper/jse12086-sm-0003-suppapp-s3.doc")
arvore<-read.tree(text=texto1)
arvore1 <- keep.tip(arvore, tip = database_data$Families_of_seed_plant) #retirar familias da arvore que nao ocorrem no neotropico

rownames(database_data)<-database_data$Families_of_seed_plant
name.check(arvore1,database_data)
length(which(database_data$Gall == 1))


############# Pagel's test - getting data
### tanins
pmg2<-database_data
taninos<-as.factor(pmg2$Tannins)
names(taninos)<-pmg2$Families_of_seed_plant
taninos

### flavonoids
flavonoids<-as.factor(pmg2$Flavonoids)
names(flavonoids)<-pmg2$Families_of_seed_plant
flavonoids

### phenols
phenols<-as.factor(pmg2$Phenolic_acids)
names(phenols)<-pmg2$Families_of_seed_plant
phenols

### galls
galhadores<-as.factor(pmg2$Gall)
names(galhadores)<-pmg2$Families_of_seed_plant
galhadores


#### Pagel's test - run models and test
######## pagel's test
PSMS_to_test<-list(taninos,flavonoids,phenols)
names_PSMS_tested <-c("taninos","flavonoids","phenols")
results_pagel_gall<-list()
for (i in seq_along(PSMS_to_test)){
  fit.AS<-fitPagel(arvore1,PSMS_to_test[[i]],galhadores,model="ARD", method = "fitDiscrete")
  
  # Dependente Y - Mudança em Area depende de Grupo Social
  fit.AR<-fitPagel(arvore1,PSMS_to_test[[i]],galhadores,dep.var="y", method = "fitDiscrete")
  
  # Comparando modelos
  aic.scores<-setNames(c(fit.AS$independent.AIC,
                         fit.AR$dependent.AIC,
                         fit.AS$dependent.AIC),
                       c("Independent",
                         "One-way dependence","Codependent"))
  aic.scores
  aics<-aicw(aic.scores)
  df <- c(attr(fit.AS$independent.logL, "df"),attr(fit.AR$dependent.logL, "df"),attr(fit.AS$dependent.logL, "df"))
  LogLikh<-c(fit.AS$independent.logL[1],fit.AR$dependent.logL[1],fit.AS$dependent.logL[1])
  resultsdip<-cbind(LogLikh,df,aics)
  results_pagel_gall[[i]]<-resultsdip
}
names(results_pagel_gall)<-names_PSMS_tested
results_pagel_gall


########## Pagel's test for each gall order - getting data

gall_psm<-database_data
### Diptera
Dipteras<-as.factor(gall_psm$Diptera)
names(Dipteras)<-gall_psm$Families_of_seed_plant
#Dipteras
### Hemiptera
Hemipteras<-as.factor(gall_psm$Hemiptera)
names(Hemipteras)<-gall_psm$Families_of_seed_plant
#Hemipteras
### Hymenoptera
Hymenopteras<-as.factor(gall_psm$Hymenoptera)
names(Hymenopteras)<-gall_psm$Families_of_seed_plant
#Hymenopteras
### Coleoptera
Coleopteras<-as.factor(gall_psm$Coleoptera)
names(Coleopteras)<-gall_psm$Families_of_seed_plant
#Coleopteras
### Lepidoptera
Lepidopteras<-as.factor(gall_psm$Lepidoptera)
names(Lepidopteras)<-gall_psm$Families_of_seed_plant
#Lepidopteras


#### Pagel's test - run models and test
######## pagel's test
PSMS_to_test<-list(taninos,flavonoids,phenols)
names_PSMS_tested <-c("taninos","flavonoids","phenols")
orders_to_test<-list(Dipteras,Hemipteras,Hymenopteras,Coleopteras,Lepidopteras)
names_orders_tested<-c("Dipteras","Hemipteras","Hymenopteras","Coleopteras","Lepidopteras")

results_pagel_order1<-list()
results_pagel_order<-list()
for(j in seq_along(orders_to_test)){
  for(i in seq_along(PSMS_to_test)){
    fit.AS<-fitPagel(arvore1,PSMS_to_test[[i]],orders_to_test[[j]],model="ARD", method = "fitDiscrete")
    
    # Dependente Y - Mudança em Area depende de Grupo Social
    fit.AR<-fitPagel(arvore1,PSMS_to_test[[i]],orders_to_test[[j]],dep.var="y", method = "fitDiscrete")

    # Comparando modelos
    aic.scores<-setNames(c(fit.AS$independent.AIC,
                           fit.AR$dependent.AIC,
                           fit.AS$dependent.AIC),
                         c("Independent",
                           "One-way dependence","Codependent"))
    aic.scores
    aics<-aicw(aic.scores)
    df <- c(attr(fit.AS$independent.logL, "df"),attr(fit.AR$dependent.logL, "df"),attr(fit.AS$dependent.logL, "df"))
    LogLikh<-c(fit.AS$independent.logL[1],fit.AR$dependent.logL[1],fit.AS$dependent.logL[1])
    resultsdip<-cbind(LogLikh,df,aics)
    results_pagel_order1[[i]]<-resultsdip
    names(results_pagel_order1[[i]])<-names_PSMS_tested[[i]]
  }
  results_pagel_order[[j]]<-results_pagel_order1
}
 
names(results_pagel_order)<-names_orders_tested
results_pagel_order_fitdiscrete<-results_pagel_order

write.csv(results_pagel_order_fitdiscrete,file="pagels_orders_fitdiscrete_final.csv",sep = "\t")
