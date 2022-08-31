---
title: "FAO Food Price Index"
author: "Kmicha71"
date: "16 5 2022"
output:
  html_document: 
    keep_md: true
  pdf_document: default
---



## FAO Food Price Index

Download the food price data from FAO (monthly)

# https://www.fao.org/worldfoodsituation/foodpricesindex/en/
# https://www.fao.org/fileadmin/templates/worldfood/Reports_and_docs/Food_price_indices_data_may629.csv


```sh

./sh/foaFood.sh

```

```
## PWD: /__w/faoFood/faoFood
## match: '_aug580'
## Try to download: https://www.fao.org/fileadmin/templates/worldfood/Reports_and_docs/Food_price_indices_data_aug580.csv
## --2022-08-31 09:59:37--  https://www.fao.org/fileadmin/templates/worldfood/Reports_and_docs/Food_price_indices_data_aug580.csv
## Resolving www.fao.org (www.fao.org)... 172.64.147.129, 104.18.40.127, 2606:4700:4400::6812:287f, ...
## Connecting to www.fao.org (www.fao.org)|172.64.147.129|:443... connected.
## HTTP request sent, awaiting response... 200 OK
## Length: 43280 (42K) [text/csv]
## Saving to: ‘../download/Food_price_indices_data_aug580.csv’
## 
##      0K .......... .......... .......... .......... ..        100% 64.2M=0.001s
## 
## 2022-08-31 09:59:38 (64.2 MB/s) - ‘../download/Food_price_indices_data_aug580.csv’ saved [43280/43280]
```



```r
food <- read.csv("./download/foaFood.csv", sep=",")
# first remove columns with completely empty values
food2 <- food[,colSums(is.na(food))<nrow(food)]
# second keep complete rows
food3 <- food2[complete.cases(food2[ , 1:7]),]
# third remove columns with some empty values
food <- food3[,colSums(is.na(food3))==0] 

food$time <- paste(food$Date, '15 00:00:00', sep='-')
food$year <- strtoi(substr(food$Date, 1, 4), base=10)
food$month <- strtoi(substr(food$Date, 6, 7), base=10)
food$ts <- signif(food$year + (food$month-0.5)/12, digits=6)
food$Date <- NULL
food <- food[order(food$ts),]

write.table(food, file = "./csv/monthly_abs_food_index.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = "escape", fileEncoding = "UTF-8")
```
## Plot Absolute Food Index


```r
require("ggplot2")
```

```
## Loading required package: ggplot2
```

```r
food <- read.csv("./csv/monthly_abs_food_index.csv", sep=",")
mp <- ggplot() +
      geom_line(aes(y=food$Food.Price.Index, x=food$ts), color="black") +
      geom_line(aes(y=food$Meat, x=food$ts), color="red") +
      geom_line(aes(y=food$Dairy, x=food$ts), color="blue") +
      geom_line(aes(y=food$Cereals, x=food$ts), color="cyan") +  
      geom_line(aes(y=food$Oil, x=food$ts), color="yellow") +  
      geom_line(aes(y=food$Sugar, x=food$ts), color="green") +  
      xlab("Year") + ylab("[]")
mp
```

![](README_files/figure-html/plot-1.png)<!-- -->




