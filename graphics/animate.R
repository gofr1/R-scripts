library(readr)
library(knitr)
library(tidyverse)
library(ggthemes)
library(gganimate)
library(ggplot2)

raw <- read_csv("https://raw.githubusercontent.com/DataHerb/dataset-covid-19/master/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

confirmed_cases <- gather(
  raw,
  "time",
  "count",
  -"Province/State",
  -"Country/Region",
  -"Lat",
  -"Long"
  ) #%>% drop_na(count)
confirmed_cases$time <- lubridate::mdy(confirmed_cases$time)

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  coord_polar() +
  coord_cartesian(ylim = c(-50, 90)) +
  theme_map()
  
animation <- world +
  geom_point(
    aes(
      x = Long,
      y = Lat,
      size = ifelse(count == 0, NA, count)
    ),
    data = confirmed_cases,
    colour = "purple",
    alpha = 0.7
  ) +
  scale_size_continuous(
    range = c(1, 8),
    breaks = c(100, 1000, 5000, 10000, 20000, 30000)
  ) +
  labs(
    size = "Confirmed cases"
  ) +
  labs(
    title = "Confirmed cases of Coronavirus",
    subtitle = "Date: {closest_state}"
  ) +
  transition_states(
    time,
    transition_length = 0,
    state_length = 1
  )
 
animate(animation, height = 620, width = 1129, renderer = gifski_renderer())
anim_save("coronavirus.gif")
