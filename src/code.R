# Install
library(help="stats")
install.packages("xxxx")
options(max.print=1000)
# Insertion dans data le jeu de données
data <- read.csv("C:/Users/amir/Desktop/ProjetTER/occupation_parking.csv", header = TRUE, sep = ';', dec = ',', stringsAsFactors = TRUE)

# Redéfinition des valeurs du jeu de données
data$id <- as.integer(data$id)
data$horodatage <- as.POSIXct(data$horodatage,format="%Y-%m-%d %H:%M:%S")
data$places_disponibles <- as.numeric(data$places_disponibles)

# Outils pour visualiser le jeu de données
head(data)
str(data)
summary(data)
summary.aov(data)
anova(data)

# Colonnes du tableau du jeu de données
data$id
data$code_parking
data$type_compteur
data$horodatage
data$places_disponibles

# Requetes SQL, determine les parkings pleins
library("sqldf")
library(tidyverse)
sqldf('SELECT code_parking, type_compteur, places_disponibles 
      FROM data 
      WHERE places_disponibles = 0 
      GROUP BY code_parking 
      HAVING count(code_parking) > 43000')



# code yacine, Graphe par moyenne
library(ggplot2)
library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(scales)
library(reshape2)
library(leaflet)
library(ggmap)
library(geojsonio)


subs<-subset(data,data$code_parking=='PMU84')
subs

res <- filter(data,code_parking== "PMU84",type_compteur =="STANDARD")
view(res)

graph <- ggplot(res) + geom_smooth(aes(x=`horodatage`, y = `places_disponibles`)) + 
  scale_x_datetime(date_breaks = "24 hour", labels = date_format("%d/%m - %H:%M"))+
  scale_y_continuous(breaks=c(0,1,2))+
  theme(axis.text.x = element_text(angle = 90, vjust = 1.0, hjust = 1.0,size = 7))
graph

#code thomas, graphe sans ponderation
library(base)
library(zoo)
#Set working directory
setwd("Series_Temporelles/HOPITAL/SaintLouis-PMO19/PMO19-STANDARD.csv")
pmo05Standard <- read.csv("pmo05_standard.csv",sep=",",header=T)
date = as.POSIXct(strptime(pmo05Standard$horodatage, "%Y-%m-%d %H:%M:%S"))
places <- as.numeric(pmo05Standard$places_disponibles)
pmo05Standard <- data.frame(date,places)
#Verify pertinence of data
#head()
#tail()
#summary()
pmo05Standard.zoo <- zoo(pmo05Standard$places, order.by = pmo05Standard$date)
plot(pmo05Standard.zoo,main="Parking STANDARD PMO05 du 12/03/21 au 26/04/21",xaxt="n",xlab="",ylab="PLACES DISPONIBLES",col="red")
t <- time(pmo05Standard.zoo)
axis.POSIXct(1, at = seq(t[1], tail(t,1), "days"), format = "%d/%m/%y" , las= 1)


#code Amir, visualisation de manière graphique une série temporelle
PMO <- read_delim("Series_Temporelles/HOPITAL/SaintLouis-PMO19/PMO19-STANDARD.csv", 
                             ";", escape_double = FALSE, col_types = cols(horodatage = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                                                          places_disponibles = col_number()), 
                             trim_ws = TRUE)

plot(PMO$horodatage, PMO$places_disponibles, type = "l", xaxt = "n", xlab = "Date",
     ylab = "Nombre de places", col = "plum4")
axis.POSIXct(1, at = seq(PMO$horodatage[1], tail(PMO$horodatage, 1), "weeks"),
             format = "%d/%m/%Y", las = 1)


# code Amir, Correlation test1
#utilisation de la fonction cor() qui retourne un coefficient de correlation ,si <= -1 ou >= 1  alors il n'y a pas de correlation
library(readr)

#PMO <- read_delim("Series_Temporelles\HOPITAL\Reuilly-Diderot - PMO73\PMO73-STANDARD.csv",";", escape_double = FALSE, trim_ws = TRUE)

PMO <- read_delim("Series_Temporelles/HOPITAL/SaintLouis-PMO19/PMO19-STANDARD.csv", 
                             ";", escape_double = FALSE, col_types = cols(horodatage = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                                                          places_disponibles = col_number()), 
                             trim_ws = TRUE)


class(PMO$places_disponibles)
class(PMO$horodatage)
#View(PMO)
PMO$horodatage = as.numeric(PMO$horodatage)
#PMO$places_disponibles <- as.numeric(PMO$places_disponibles)
cor(PMO$places_disponibles,PMO$horodatage)


cor.test(PMO$places_disponibles, PMO$horodatage, alternative = 'greater', conf.level = 0.99)

correlation <- lm(places_disponibles ~ horodatage, data = PMO)
summary(correlation)

#predict.lm(correlation, newdata = data.frame( PMO$horodatage = 1616695120))




# code Amir, Correlation test2
# utilisation de l'interface graphique rattle qui fait des correlations entre les tables
#install.packages("xxxxxx")
library(sp)
library(bitops)
library(tibble)
library(RGtk2)
library(raster)
library(rattle)
C:\Users\amir\Desktop\ProjetTER\Series_Temporelles\CULTURE\Rivoli-Sébastopol - PMO23

# code Amir, Correlation test3
library(base)
library(zoo)
library(caschrono)
library(dygraphs)
library(xts)
library(readr)
library(TTR)
library(quadprog)
library(quantmod)
library(tseries)
# PMO04J.csv
# PMO08J.csv
# PMO10J.csv
# PMO11J.csv
# PMO19J.csv
# PMO23J.csv
# PMO26J.csv
# PMO95J.csv
PMO <- read_delim("C:/Users/amir/Desktop/ProjetTER/Donnees_Nettoyer/PMO10.csv",";", escape_double = FALSE, col_types = cols(horodatage = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                                                                                                          places_disponibles = col_number()), 
                  trim_ws = TRUE)





acf(PMO,lag.max=60)
#Verifie les types
class(PMO$places_disponibles)
class(PMO$places_disponibles)

# acf estime l'autocorrélation, il représente par défaut les autocorrélations sur un graphique appelé l'autocorrélogramme.
#Autocorrélogramme :

spectrum(PMO)
par(PMO)
POM <- ts(PMO, start = 25, frequency = 24*30)
acf(POM)


#Le nuage de point de la série en fonction de la série retardée d'une heure le confirme:
places_disponibles<-ts(data$places_disponibles)
plot(stats::lag(places_disponibles,1),places_disponibles,pch=20,cex=0.8)

