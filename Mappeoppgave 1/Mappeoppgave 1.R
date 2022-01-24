library(tidyverse)
library(lubridate)
library(zoo)
library(janitor)
library(plyr)

#Oppgave 1.

lower <- 
  read_table("https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt") %>% 
  .[1:which(.$Year %in% "Year")-1, ] %>% 
  clean_names() %>% 
  .[ , 1:3] %>%  
  mutate(dato = ymd(paste(.$year, .$mo, 1, sep = "-"))) %>% 
  mutate_if(is.character, ~as.numeric(.)) %>% 
  select(dato, globe) %>% 
  mutate(glidende_snitt = rollmean(globe, 13, fill = NA, align = "center")) 

lower %>% 
  ggplot(aes(x=dato, y=globe)) + 
  geom_line(col="blue") + 
  theme_bw() +
  geom_point(shape=1,col="blue") +
  geom_line(aes(y=glidende_snitt), col="red", lwd=1.2) + 
  labs(x = "Latest Global Average Tropospheric Tempratures", 
       y = "T Depature from 91-20 Avg. (deg.C)", 
       title = "UAH Satellite-Based Temperatureog the Global Lower Atmosphere (Version 6.0)") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_x_date(date_breaks = "1 years", date_labels = "%Y") + 
  scale_y_continuous( 
    expand = c(0,0.03), 
    breaks = seq(from = -0.7,
                 to = 1,
                 by = 0.1), 
    labels = scales::number_format(accuracy = 0.1, decimal.mark = '.'))

#Oppgave 2:

scrape_bake <- function(url, location) {
  return(read_table(url) %>% 
           .[1:which(.$Year %in% "Year")-1, ] %>% 
           clean_names() %>% 
           mutate(dato = ymd(paste(.$year, .$mo, 1, sep = "-"))) %>% 
           mutate_if(is.character, ~as.numeric(.)) %>% 
           mutate(nivå = paste0(location)))
}
url_list <- list("http://vortex.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt",
                 "http://vortex.nsstc.uah.edu/data/msu/v6.0/tmt/uahncdc_mt_6.0.txt",
                 "http://vortex.nsstc.uah.edu/data/msu/v6.0/ttp/uahncdc_tp_6.0.txt",
                 "http://vortex.nsstc.uah.edu/data/msu/v6.0/tls/uahncdc_ls_6.0.txt")
location_list <- list("Lower Tropos","Mid-Tropos", "Tropop", "Lower Stratos")

d.frame <- map2(url_list, location_list, scrape_bake)
d.frame <- ldply(d.frame, data.frame)
d.frame <- d.frame %>%  
  select(dato, no_pol, nivå) %>% 
  as_tibble() %>% 
  mutate(gj.snitt.alle = rollmean(no_pol, 13, fill = NA, align = "center"))

ggplot(d.frame, aes(x = dato, y = no_pol, color = nivå)) + 
  geom_line(linetype = "dashed", lwd=0.9) + 
  theme_bw() + 
  geom_point(shape = 1) + 
  geom_line(aes(y=gj.snitt.alle), col="yellow", lwd = 0.2) + 
  ggtitle("Temperaturen på fire nivå av atmosfæren i området 60°- 90° nord \n med gjennomsnitt ") + 
  labs(y="Temperatur (deg.C)", x="Gjennomsnittlig temperaturendring") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") + 
  scale_y_continuous( 
    expand = c(0,0), 
    breaks = seq(from = -9,
                 to = 9.5,
                 by = 1), 
    labels = scales::number_format(accuracy = 0.1, decimal.mark = '.'))
  















