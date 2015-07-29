
#install.packages("httr")
#install.packages("XML")
library(XML)
library(httr)

#get the variables:
statesindex = read.table("state.txt",header = TRUE,sep = "|",colClasses=c(STATE="character"))
varsindex = read.table("var_index.txt", header = TRUE, sep= "\t")
zipcounty = read.table("zcta_county_rel_10.txt", header=TRUE, sep=",", colClasses=c(ZCTA5="character", STATE="character",COUNTY="character"))
zipcounty = zipcounty[,1:3]


vars = lapply(varsindex["index"], function(x) paste(x, sep='', collapse=","))
states = lapply(statesindex["STATE"], function(x) paste(x, sep='', collapse=","))
zips=lapply(zipcounty["ZCTA5"], function(x) paste(x, sep='', collapse=","))

names = varsindex["name"]
names = rbind(names,data.frame(name ="zip"))

start=seq(1, 44411, by=1000)
APIkey="your key" ####your API key
url="http://api.census.gov/data/2013/acs5?get="


for (i in start){
  end = i+1000-1
  if(end>44410){end = 44410}
  temp=zipcounty[i:end,1:3]
  zips=lapply(temp["ZCTA5"], function(x) paste(x, sep='', collapse=","))
  
  query=paste(url, vars, "&for=zip+code+tabulation+area:",zips,"&key=",APIkey,sep='')

  dat_raw = try(readLines(query, warn="F"))
  
  tmp =strsplit(gsub("[^[:alnum:], _]", '', dat_raw), "\\,")

  dat_df = as.data.frame(do.call(rbind, tmp[-1]), stringsAsFactors=FALSE)
  if (i ==1){
      all<-dat_df}
  else{
    all <- rbind(all, dat_df)
  }
}  


names(all) <- names[[1]]

write.csv(all, 'acs_data_zip.csv', row.names = FALSE)
