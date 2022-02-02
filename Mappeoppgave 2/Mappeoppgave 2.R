library(rjson)
library(tidyverse)

#henter ut JSON-filen fra nettsiden:
jsondata <- 
  fromJSON(file = "https://static01.nyt.com/newsgraphics/2021/12/20/us-coronavirus-deaths-2021/ff0adde21623e111d8ce103fedecf7ffc7906264/scatter.json")

#binder jsondata til et datasett og skifter navn:
my_df <- do.call(rbind.data.frame, jsondata)
my_df <- my_df %>% 
  rename(fully = fully_vaccinated_pct_of_pop)

#Lager et plot som er tilnærmet lik:
ggplot(my_df, aes(x=fully, y=deaths_per_100k, label = name)) + 
  geom_point(color = "#9AC0CD", size = 2) + 
  theme_bw() + 
  geom_text(hjust=0.5, vjust=-1, size = 2) + 
  annotate(geom="text", x=0.73, y=9, 
           label="Higher vaccination rate, \n lower death rate -->",
           color="black", size = 3) + 
  annotate(geom="text", x=0.58, y=17, 
           label="Lower vaccination rate, \n <-- higher death rate",
           color="black", size  = 3) + 
  scale_x_continuous(labels = scales::percent, 
                     breaks = seq(from = 0,
                                  to = 1,
                                  by = 0.05)) + 
  labs(title = "Covid-19 deaths since universal adult vaccine eligibility compared with\n 
                                              vaccination rates \n 
       
    20.avg. montlhy deaths per 100,000",
       x = "Share of total population fully vaccinated", 
       y = " ")
  

# Oppgave 2:

ggplot(my_df, aes(x=fully, y=deaths_per_100k, label = name,
                  lm(fully ~ deaths_pet_100k, data = my_df)))+ 
  geom_point(color = "#9AC0CD", size = 2) + theme_bw() + 
  geom_smooth(method="lm", color = "grey") +
  geom_text(hjust=0.5, vjust=-1, size = 2) + 
  annotate(geom="text", x=0.73, y=9, 
           label="Higher vaccination rate, \n lower death rate -->",
           color="black", size = 3) + 
  annotate(geom="text", x=0.58, y=17, 
           label="Lower vaccination rate, \n <-- higher death rate",
           color="black", size  = 3) + 
  scale_x_continuous(labels = scales::percent, 
                     breaks = seq(from = 0,
                                  to = 1,
                                  by = 0.05)) + 
  labs(title = "Covid-19 deaths since universal adult vaccine eligibility compared with\n 
                                                    vaccination rates \n 
       
       20.avg. montlhy deaths per. 100,000",
       x = "Share of total population fully vaccinated", 
       y = " ")

