#install.packages("VennDiagram")
library(VennDiagram)
setwd("/Users/carol/Documents/gall_PSM_paper")
database_data<-read.csv("gall_psm_final.csv", sep=",", header=T)
str(database_data)

sum(database_data$Gall)
somas<-vector()
for(i in 1:nrow(database_data)){
  somas[i]<- sum(database_data[i,3:6])
}
length(which(somas==0))


#pmg<-utils::read.csv("metabl-gall-neotr.csv",sep=",", header=T)
#nomes_filtrados <- pmg$Families_of_seed_plant[pmg$presence_neotropical == 0]
#rownames(pmg)<-pmg$Families_of_seed_plant
#pmg2 <- pmg[!(rownames(pmg) %in% nomes_filtrados), ]#remove data from families that don't occur on Neotropics
#pmg2<-galls
diagram_data <- list(
  "Tannins" = database_data[database_data[, "Tannins"] == 1, "Families_of_seed_plant"],
  "Flavonoids" = database_data[database_data[, "Flavonoids"] == 1, "Families_of_seed_plant"],
  "Phenolic_acid" = database_data[database_data[, "Phenolic_acids"] == 1, "Families_of_seed_plant"],
  "Galls" = database_data[database_data[, "Gall"] == 1, "Families_of_seed_plant"])

str(diagram_data)
# Criar o diagrama de Venn
cores<-c("yellow","blue", "green", "red")

venn.plot <- venn.diagram(
  x = diagram_data,
  category.names = c("Tannins", "Flavonoids", "Phenolic_acid", "Galls"),
  filename = NULL,
  fill=cores,
  cat.cex = 6,                 # Tamanho do texto das categorias (nomes)
  cex = 6 
)
# Visualizar o diagrama
grid.draw(venn.plot)

dev.off()
# Criar o diagrama de Venn para flavonoides
Flavonoid_gall <- list(
  "Flavonoids" = pmg2[pmg2[, "Flavonoids"] == 1, "Families_of_seed_plant"],
  "Galls" = pmg2[pmg2[, "Gall"] == 1, "Families_of_seed_plant"])


venn.plot1 <- venn.diagram(
  x = Flavonoid_gall,
  category.names = c("Flavonoids", "Galls"),
  filename = NULL,
  fill = c("red","blue")
)

grid.draw(venn.plot1)
dev.off()
# Visualizar o diagrama para ac. fenólicos
Phenolic_gall <- list(
  "Phenolic_acid" = pmg2[pmg2[, "Phenolic_acids"] == 1, "Families_of_seed_plant"],
  "Galls" = pmg2[pmg2[, "Gall"] == 1, "Families_of_seed_plant"])


venn.plot2 <- venn.diagram(
  x = Phenolic_gall,
  category.names = c("Phenolic_acid", "Galls"),
  filename = NULL,
  fill = c("red","blue")
)

grid.draw(venn.plot2)

str(diagram_data)
