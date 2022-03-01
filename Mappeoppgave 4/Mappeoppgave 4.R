library(rvest)
library(tidyverse)
library(rlist)

#Lager en liste med de fagene som instruert i oppgaven: 

url_list <- 
  list("https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=4-20&View=list",
       "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module[]=SOK-1006-1&week=4-20&View=list",
       "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1016-1&week=4-20&View=list")

#Lager en funksjon med de trinnene som er gitt i mappeoppgave 4: 
#Men gjør selve instruksen til om til en annerledes kode: 

timeplan_rydd <- function(url) {
  side <- read_html(url)
  tabellen <- html_nodes(side, 'table') 
  tabellen <- html_table(tabellen, fill=TRUE) 
  listen <- list.stack(tabellen) # stack the list into a data frame
  colnames(listen) <- listen[1,]
  listen <- listen %>% filter(!Dato=="Dato")
  listen <- listen %>% separate(Dato, 
                                into = c("Dag", "Dato"), 
                                sep = "(?<=[A-Za-z])(?=[0-9])")
  listen <- listen[-length(listen$Dag),]
  listen$Dato <- as.Date(listen$Dato, format="%d.%m.%Y")
  listen$Uke <- strftime(listen$Dato, format = "%V")
  listen <- listen %>% select(Dag,Dato,Uke,Tid,Rom, Lærer, Emnekode)
  return(listen)
}


timeplan <- map(url_list, timeplan_rydd ) 

timeplan
