#!/bin/bash

# extract current csv url first
olddir="$pwd"
cd "/cre/R/sh"

[ -f ../download/index.html ] && mv -f ../download/index.html ../download/index.html.bck
wget -q -P ../download https://www.fao.org/worldfoodsituation/foodpricesindex/en/
grep "CSV" ../download/index.html | grep "Food_price_indices_data" > ../download/index.txt
ancor="$(cat ../download/index.txt)"

# download csv file
if [[ $ancor =~ (Food_price_indices_data)([^.csv]*) ]]; then
  echo "match: '${BASH_REMATCH[2]}'"
  filepostfix=${BASH_REMATCH[2]}
  urlcsv="https://www.fao.org/fileadmin/templates/worldfood/Reports_and_docs/Food_price_indices_data$filepostfix.csv"
  [ -f ../download/foaFood.csv ] && mv -f ../download/foaFood.csv ../download/foaFood.csv.bck
  echo "Try to download: $urlcsv"
  wget -P ../download $urlcsv
  mv "../download/Food_price_indices_data$filepostfix.csv" ../download/foaFood.csv.tmp
  tail -n +3 ../download/foaFood.csv.tmp > ../download/foaFood.csv
  rm -f ../download/foaFood.csv.tmp 
else
  echo "no csv download file found"
fi

cd $olddir
