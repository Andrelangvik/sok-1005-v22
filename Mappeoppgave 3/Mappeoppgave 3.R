library(tidyverse)
library(rvest)
library(dplyr)

#Denne er gjort i et samarbeid med Mathias Hetland og Martin Smedstad
#Data er hentet fra: https://www.motor.no/aktuelt/motors-store-vintertest-av-rekkevidde-pa-elbiler/217132

#Laster ned html-en:
link <- read_html("https://www.motor.no/aktuelt/motors-store-vintertest-av-rekkevidde-pa-elbiler/217132")

#Henter ut tabellen og fjerner rader og kolonner som ikke skal være med, og verdier uten tall:
tabellen <- link %>% 
  html_node("body") %>% 
  html_table(header = TRUE) 

#Fjerner ting som ikke skal være med i observasjonene og rydder opp i tabellen: 
tabellen <- tabellen %>% 
  select(modell = starts_with("Modell"), wltp = starts_with("WLTP"), stopp = STOPP, avvik = Avvik) %>% 
  slice(-c(19, 26)) %>% 
  slice((1:(n()- 34))) %>% 
  separate(wltp, sep = "/", into = c("wltp", "kWh")) %>% 
  mutate_at("stopp", str_replace, "km", "") %>% 
  mutate_at("wltp", str_replace, "km", "") %>% 
  mutate_at("wltp", str_replace, "kWh", "") %>% 
  mutate_at("avvik", str_replace, "%", "") %>%
  mutate(avvik = str_replace(avvik, ",", "."), 
         kWh = str_replace(kWh, ",", "."))

#gjør 3 av 5 kolonner om til numeric fra charatcer. 
tabellen$stopp <- as.numeric(tabellen$stopp)
tabellen$wltp <- as.numeric(tabellen$wltp)
tabellen$avvik <- as.numeric(tabellen$avvik)

str(tabellen)

#gjennskape plot fra oppgaven:
ggplot(tabellen, aes(x=wltp, y=stopp)) + 
  geom_point() + 
  theme_bw() + theme_classic() +   
  scale_x_continuous(breaks = seq(from = 200, to = 600, by = 100), limits = c(200, 600)) +
  scale_y_continuous(breaks = seq(from = 200, to = 600, by = 100), limits = c(200, 600)) + 
  geom_abline(size = 0.5, col  ="red") + 
  labs(title = "Forhold mellom oppgitt kjørelengde og faktsik kjørelengde", 
       x = "WLTP - oppitt kjørelengde ", 
       y = "Stopp - faktisk kjørelengde")


#Oppgave 2: 

print(lm(stopp ~ wltp, data = tabellen))

ggplot(tabellen, aes(x=wltp, y=stopp)) + 
  geom_point() + 
  theme_bw() + theme_classic() +   
  scale_x_continuous(breaks = seq(from = 200, to = 600, by = 100), limits = c(200, 600)) +
  scale_y_continuous(breaks = seq(from = 200, to = 600, by = 100), limits = c(200, 600)) + 
  geom_abline(size = 0.5, col  ="red") + 
  labs(title = "Forhold mellom oppgitt kjørelengde og faktsik kjørelengde \n - med en linærregrisjon", 
       x = "WLTP - oppitt kjørelengde ", 
       y = "Stopp - faktisk kjørelengde") + geom_smooth(method = lm, color = "red")






#Kilder


 



  
  










  
  




