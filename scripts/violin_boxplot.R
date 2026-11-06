rm(list=ls())
library(dplyr)
library(tidyverse)
library(ggpubr)

setwd("/Users/carol/Documents/gall_PSM_paper")

database_data<-read.csv("gall_psm_final.csv", sep=",", header=T)
str(database_data)
####### sum PSMs
No_of_PSMs<-vector()
for (i in 1:nrow(database_data)){
  No_of_PSMs[i]<-sum(database_data[i,3:5])
}

pmg2<-cbind(database_data,No_of_PSMs)

str(pmg2)

############# boxplot number of secondary metabolites x presence of galls
boxplot_abundancia <- ggboxplot(pmg2, 
                                x="Gall", 
                                y="No_of_PSMs", 
                                fill="steelblue",
                                xlab = "gall",
                                ylab = "PSMs")+
  labs(title="Galls and PSMs")+
  theme(plot.title = element_text(hjust = 0.5))

#Agora, plotando o objeto criado
boxplot_abundancia



barplot_abundancia <- ggplot(pmg2, aes(x = factor(Gall), fill = factor(No_of_PSMs))) +
  geom_bar(position = "stack") +
  labs(x = "Gall Presence", y = "Count", fill = "PSMs",
       title = "Galls and PSMs (Barplot)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


barplot_abundancia

# Pacotes necessários
library(ggplot2)
library(reshape2)  # Para manipular os dados

# Criar a tabela de contagem
heatmap_data <- as.data.frame(table(pmg2$Gall, pmg2$No_of_PSMs))
colnames(heatmap_data) <- c("gall_presence", "psm_sums", "count")

# Gráfico de Heatmap
heatmap_abundancia <- ggplot(heatmap_data, aes(x = No_of_PSMs, y = gall_presence, fill = count)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(x = "PSMs", y = "Gall Presence", fill = "Count",
       title = "Heatmap of Galls and PSMs") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

heatmap_abundancia

ggviolin(data = pmg2, 
         x="Gall", 
         y="No_of_PSMs", 
         #fill="#8a9a5b",
         fill="steelblue",
         add = "boxplot", add.params = list(fill = "white",alpha=0.65)) +
  stat_compare_means(label.y = 5, label.x = 2) +
  scale_x_discrete(labels = c("0" = "Absent", "1" = "Present"))+
  labs(x = "Gall absence/presence in neotropical plant families",
       y = "Number of PSMs") +
  theme(plot.margin = margin(t = 50, r = 50, b = 50, l = 50),
        plot.title = element_text(hjust = 1),
        axis.text = element_text(size = 50),       
        axis.title = element_text(size = 60),
        axis.title.x = element_text(margin = margin(t = 90)),
        axis.title.y = element_text(margin = margin(t = 90))
        )



shapiro.test(pmg2$No_of_PSMs[pmg2$Gall == 0])
shapiro.test(pmg2$No_of_PSMs[pmg2$Gall == 1])
resultado_wilcox <- wilcox.test(No_of_PSMs ~ Gall, data = pmg2)
